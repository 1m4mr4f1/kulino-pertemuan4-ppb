import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/transaction_record.dart';
import '../repositories/product_repository.dart';
import '../repositories/product_repository_impl.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/transaction_repository_impl.dart';

class PosProvider extends ChangeNotifier {
  final ProductRepository productRepository;
  final TransactionRepository transactionRepository;

  List<Product> _products = [];
  bool _isLoadingProducts = false;
  bool _isOffline = false;
  String? _statusMessage;

  final List<CartItem> _cart = [];
  List<TransactionRecord> _transactions = [];
  bool _isLoadingTransactions = false;

  PosProvider({
    ProductRepository? productRepository,
    TransactionRepository? transactionRepository,
  })  : productRepository = productRepository ?? ProductRepositoryImpl(),
        transactionRepository =
            transactionRepository ?? TransactionRepositoryImpl();

  List<Product> get products => _products;
  bool get isLoadingProducts => _isLoadingProducts;
  bool get isOffline => _isOffline;
  String? get statusMessage => _statusMessage;

  List<CartItem> get cart => List.unmodifiable(_cart);
  List<TransactionRecord> get transactions =>
      List.unmodifiable(_transactions);
  bool get isLoadingTransactions => _isLoadingTransactions;

  int get totalCartCount =>
      _cart.fold(0, (sum, item) => sum + item.quantity);
  int get totalCartPrice =>
      _cart.fold(0, (sum, item) => sum + item.subtotal);

  Future<void> loadProducts({bool forceRefresh = false}) async {
    _isLoadingProducts = true;
    notifyListeners();

    final result = await productRepository.fetchProducts(
      forceRefresh: forceRefresh,
    );

    _products = result.products;
    _isOffline = result.isFromCache;
    _statusMessage = result.errorMessage;
    _isLoadingProducts = false;
    notifyListeners();
  }

  void addToCart(Product product, {int quantity = 1, String notes = ''}) {
    HapticFeedback.lightImpact();

    final index = _cart.indexWhere(
      (item) => item.product.id == product.id && item.notes == notes,
    );

    if (index >= 0) {
      _cart[index].quantity += quantity;
    } else {
      _cart.add(CartItem(
        product: product,
        quantity: quantity,
        notes: notes,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    HapticFeedback.selectionClick();
    if (newQuantity <= 0) {
      _cart.removeAt(index);
    } else {
      _cart[index].quantity = newQuantity;
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    HapticFeedback.mediumImpact();
    if (index >= 0 && index < _cart.length) {
      _cart.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    HapticFeedback.mediumImpact();
    _cart.clear();
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    _isLoadingTransactions = true;
    notifyListeners();

    _transactions = await transactionRepository.getTransactions();
    _isLoadingTransactions = false;
    notifyListeners();
  }

  Future<void> clearTransactions() async {
    HapticFeedback.heavyImpact();
    await transactionRepository.clearTransactions();
    _transactions = [];
    notifyListeners();
  }

  Future<Position?> getCurrentDeviceLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          timeLimit: Duration(seconds: 3),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Future<TransactionRecord> processCheckout({
    required int paidAmount,
    required String paymentMethod,
  }) async {
    HapticFeedback.mediumImpact();

    Position? location;
    try {
      location = await getCurrentDeviceLocation();
    } catch (_) {}

    final transaction = TransactionRecord(
      id: 'TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      timestamp: DateTime.now(),
      items: List.from(_cart),
      totalAmount: totalCartPrice,
      paidAmount: paidAmount,
      changeAmount: paymentMethod == 'QRIS' ? 0 : (paidAmount - totalCartPrice),
      paymentMethod: paymentMethod,
      latitude: location?.latitude,
      longitude: location?.longitude,
    );

    await transactionRepository.saveTransaction(transaction);
    _transactions.add(transaction);
    _cart.clear();

    HapticFeedback.vibrate();
    notifyListeners();

    return transaction;
  }
}

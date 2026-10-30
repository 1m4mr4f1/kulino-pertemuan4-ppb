import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:warung_pos/models/product.dart';
import 'package:warung_pos/models/cart_item.dart';
import 'package:warung_pos/models/transaction_record.dart';
import 'package:warung_pos/repositories/product_repository.dart';
import 'package:warung_pos/repositories/product_repository_impl.dart';
import 'package:warung_pos/repositories/transaction_repository_impl.dart';
import 'package:warung_pos/providers/pos_provider.dart';
import 'package:warung_pos/screens/catalog_screen.dart';
import 'package:warung_pos/screens/item_detail_screen.dart';
import 'package:warung_pos/screens/cart_screen.dart';
import 'package:warung_pos/screens/receipt_screen.dart';
import 'package:warung_pos/screens/history_screen.dart';
import 'package:warung_pos/theme/app_theme.dart';

class MockHttpClient extends http.BaseClient {
  final int statusCode;
  final String body;

  MockHttpClient({this.statusCode = 200, required this.body});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final stream = Stream.value(utf8.encode(body));
    return http.StreamedResponse(stream, statusCode);
  }
}

class FakeProductRepository implements ProductRepository {
  final List<Product> mockList;

  FakeProductRepository([List<Product>? list])
      : mockList = list ??
            [
              const Product(
                id: 'p1',
                name: 'Nasi Goreng Spesial',
                category: 'Makanan',
                price: 22000,
                description: 'Enak',
                iconName: 'lunch_dining',
              ),
              const Product(
                id: 'p5',
                name: 'Es Teh Manis',
                category: 'Minuman',
                price: 5000,
                description: 'Segar',
                iconName: 'local_drink',
              ),
            ];

  @override
  Future<ProductFetchResult> fetchProducts({bool forceRefresh = false}) async {
    return ProductFetchResult(products: mockList, isFromCache: false);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Model Unit Tests', () {
    test('Product serialization and deserialization', () {
      const product = Product(
        id: 'p1',
        name: 'Ayam Goreng',
        category: 'Makanan',
        price: 25000,
        description: 'Gurih',
        iconName: 'dinner_dining',
      );

      final json = product.toJson();
      final fromJson = Product.fromJson(json);

      expect(fromJson.id, 'p1');
      expect(fromJson.name, 'Ayam Goreng');
      expect(fromJson.category, 'Makanan');
      expect(fromJson.price, 25000);
      expect(fromJson.description, 'Gurih');
      expect(fromJson.iconName, 'dinner_dining');
    });

    test('CartItem calculation and serialization', () {
      const product = Product(
        id: 'p2',
        name: 'Es Jeruk',
        category: 'Minuman',
        price: 7000,
        description: 'Manis',
        iconName: 'local_bar',
      );

      final item = CartItem(product: product, quantity: 3, notes: 'Sedikit es');
      expect(item.subtotal, 21000);

      final json = item.toJson();
      final fromJson = CartItem.fromJson(json);

      expect(fromJson.product.name, 'Es Jeruk');
      expect(fromJson.quantity, 3);
      expect(fromJson.notes, 'Sedikit es');
      expect(fromJson.subtotal, 21000);
    });

    test('TransactionRecord serialization and GPS tagging', () {
      const product = Product(
        id: 'p3',
        name: 'Soto Ayam',
        category: 'Makanan',
        price: 20000,
        description: 'Hangat',
        iconName: 'soup_kitchen',
      );

      final item = CartItem(product: product, quantity: 2);
      final transaction = TransactionRecord(
        id: 'TRX-999',
        timestamp: DateTime(2026, 10, 31, 10, 0),
        items: [item],
        totalAmount: 40000,
        paidAmount: 50000,
        changeAmount: 10000,
        paymentMethod: 'Tunai',
        latitude: -6.9922,
        longitude: 110.4201,
      );

      final json = transaction.toJson();
      final fromJson = TransactionRecord.fromJson(json);

      expect(fromJson.id, 'TRX-999');
      expect(fromJson.items.length, 1);
      expect(fromJson.totalAmount, 40000);
      expect(fromJson.paidAmount, 50000);
      expect(fromJson.changeAmount, 10000);
      expect(fromJson.paymentMethod, 'Tunai');
      expect(fromJson.latitude, -6.9922);
      expect(fromJson.longitude, 110.4201);
    });
  });

  group('Repository Unit Tests', () {
    test('ProductRepositoryImpl parses HTTP success and caches locally',
        () async {
      final mockJson = jsonEncode([
        {
          'id': 'api_1',
          'name': 'Menu API',
          'category': 'Makanan',
          'price': 15000,
          'description': 'Dari server',
          'iconName': 'fastfood',
        }
      ]);

      final client = MockHttpClient(statusCode: 200, body: mockJson);
      final repo = ProductRepositoryImpl(client: client);

      final result = await repo.fetchProducts(forceRefresh: true);
      expect(result.products.length, 1);
      expect(result.products.first.name, 'Menu API');
      expect(result.isFromCache, isFalse);

      final cachedResult = await repo.fetchProducts(forceRefresh: false);
      expect(cachedResult.products.length, 1);
      expect(cachedResult.isFromCache, isTrue);
    });

    test('ProductRepositoryImpl fallbacks to cache on HTTP error', () async {
      final client = MockHttpClient(statusCode: 500, body: 'Internal Error');
      final repo = ProductRepositoryImpl(client: client);

      final result = await repo.fetchProducts(forceRefresh: true);
      expect(result.products.isNotEmpty, isTrue);
      expect(result.isFromCache, isTrue);
      expect(result.errorMessage, isNotNull);
    });

    test('TransactionRepositoryImpl stores, retrieves, and clears records',
        () async {
      final repo = TransactionRepositoryImpl();

      final initial = await repo.getTransactions();
      expect(initial.isEmpty, isTrue);

      final trx = TransactionRecord(
        id: 'TRX-001',
        timestamp: DateTime.now(),
        items: [],
        totalAmount: 10000,
        paidAmount: 10000,
        changeAmount: 0,
        paymentMethod: 'QRIS',
      );

      await repo.saveTransaction(trx);
      final stored = await repo.getTransactions();
      expect(stored.length, 1);
      expect(stored.first.id, 'TRX-001');

      await repo.clearTransactions();
      final afterClear = await repo.getTransactions();
      expect(afterClear.isEmpty, isTrue);
    });
  });

  group('PosProvider Unit Tests', () {
    test('cart operations: add, increment, different notes, remove, clear',
        () {
      final provider = PosProvider(
        productRepository: FakeProductRepository(),
        locationProvider: () async => null,
      );
      const p1 = Product(
        id: 'p1',
        name: 'Nasi Goreng',
        category: 'Makanan',
        price: 20000,
        description: '',
        iconName: 'lunch_dining',
      );

      provider.addToCart(p1, quantity: 1, notes: '');
      expect(provider.cart.length, 1);
      expect(provider.totalCartCount, 1);
      expect(provider.totalCartPrice, 20000);

      provider.addToCart(p1, quantity: 2, notes: '');
      expect(provider.cart.length, 1);
      expect(provider.totalCartCount, 3);
      expect(provider.totalCartPrice, 60000);

      provider.addToCart(p1, quantity: 1, notes: 'Pedas');
      expect(provider.cart.length, 2);
      expect(provider.totalCartCount, 4);

      provider.updateQuantity(0, 5);
      expect(provider.cart[0].quantity, 5);

      provider.updateQuantity(1, 0);
      expect(provider.cart.length, 1);

      provider.removeFromCart(0);
      expect(provider.cart.isEmpty, isTrue);
      expect(provider.totalCartPrice, 0);
    });

    test('checkout flow records transaction and resets cart', () async {
      final provider = PosProvider(
        productRepository: FakeProductRepository(),
        locationProvider: () async => null,
      );
      const p1 = Product(
        id: 'p1',
        name: 'Nasi Goreng',
        category: 'Makanan',
        price: 20000,
        description: '',
        iconName: 'lunch_dining',
      );

      provider.addToCart(p1, quantity: 2);
      expect(provider.totalCartPrice, 40000);

      final trx = await provider.processCheckout(
        paidAmount: 50000,
        paymentMethod: 'Tunai',
      );

      expect(trx.totalAmount, 40000);
      expect(trx.paidAmount, 50000);
      expect(trx.changeAmount, 10000);
      expect(trx.paymentMethod, 'Tunai');
      expect(provider.cart.isEmpty, isTrue);
      expect(provider.transactions.length, 1);

      await provider.clearTransactions();
      expect(provider.transactions.isEmpty, isTrue);
    });
  });

  group('Widget Feature Tests', () {
    Widget buildTestApp(Widget child, [PosProvider? customProvider]) {
      final provider = customProvider ??
          PosProvider(
            productRepository: FakeProductRepository(),
            locationProvider: () async => null,
          );
      return ChangeNotifierProvider<PosProvider>.value(
        value: provider..loadProducts(),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: child,
        ),
      );
    }

    testWidgets('CatalogScreen renders products and searches menu',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp(const CatalogScreen()));
      await tester.pumpAndSettle();

      expect(find.text('WarungPOS'), findsOneWidget);
      expect(find.text('Nasi Goreng Spesial'), findsOneWidget);
      expect(find.text('Es Teh Manis'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Nasi');
      await tester.pumpAndSettle();

      expect(find.text('Nasi Goreng Spesial'), findsOneWidget);
      expect(find.text('Es Teh Manis'), findsNothing);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(find.text('Es Teh Manis'), findsOneWidget);
    });

    testWidgets('CatalogScreen filter categories',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp(const CatalogScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, 'Minuman'));
      await tester.pumpAndSettle();

      expect(find.text('Es Teh Manis'), findsOneWidget);
      expect(find.text('Nasi Goreng Spesial'), findsNothing);
    });

    testWidgets('ItemDetailScreen customizes portion and notes',
        (WidgetTester tester) async {
      const product = Product(
        id: 'p1',
        name: 'Ayam Bakar',
        category: 'Makanan',
        price: 25000,
        description: 'Bumbu madu',
        iconName: 'dinner_dining',
      );

      CartItem? addedItem;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  addedItem = await Navigator.push<CartItem>(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const ItemDetailScreen(product: product),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Ayam Bakar'), findsWidgets);
      expect(find.text('Rp 25000'), findsWidgets);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Pedes manis');
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -350));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tambahkan ke Keranjang (Rp 50000)'));
      await tester.pumpAndSettle();

      expect(addedItem, isNotNull);
      expect(addedItem!.quantity, 2);
      expect(addedItem!.notes, 'Pedes manis');
    });

    testWidgets('CartScreen handles empty state and checkout',
        (WidgetTester tester) async {
      final provider = PosProvider(
        productRepository: FakeProductRepository(),
        locationProvider: () async => null,
      );
      const product = Product(
        id: 'p1',
        name: 'Nasi Goreng',
        category: 'Makanan',
        price: 20000,
        description: '',
        iconName: 'lunch_dining',
      );

      await tester.pumpWidget(buildTestApp(const CartScreen(), provider));
      await tester.pumpAndSettle();

      expect(find.text('Keranjang Belanja Kosong'), findsOneWidget);

      provider.addToCart(product, quantity: 1);
      await tester.pumpAndSettle();

      expect(find.text('Nasi Goreng'), findsOneWidget);
      expect(find.text('Rp 20000'), findsWidgets);

      await tester.tap(find.text('QRIS'));
      await tester.pumpAndSettle();
      expect(find.text('QRIS Siap Di-scan Pelanggan (Nominal Otomatis)'),
          findsOneWidget);

      await tester.tap(find.text('Tunai'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Uang Pas'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Selesaikan Transaksi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Struk Pembayaran'), findsOneWidget);
    });

    testWidgets('ReceiptScreen renders receipt and copies ID',
        (WidgetTester tester) async {
      const product = Product(
        id: 'p1',
        name: 'Soto Ayam',
        category: 'Makanan',
        price: 20000,
        description: '',
        iconName: 'soup_kitchen',
      );
      final transaction = TransactionRecord(
        id: 'TRX-12345',
        timestamp: DateTime(2026, 10, 31, 12, 30),
        items: [CartItem(product: product, quantity: 1)],
        totalAmount: 20000,
        paidAmount: 20000,
        changeAmount: 0,
        paymentMethod: 'Tunai',
        latitude: -6.99,
        longitude: 110.42,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ReceiptScreen(transaction: transaction),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('TRX-12345'), findsOneWidget);
      expect(find.text('Soto Ayam x1'), findsOneWidget);
      expect(find.text('GPS Hardware'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.copy));
      await tester.pumpAndSettle();
      expect(find.text('Nomor transaksi disalin ke clipboard'), findsOneWidget);
    });

    testWidgets('HistoryScreen displays stored transactions',
        (WidgetTester tester) async {
      final provider = PosProvider(
        productRepository: FakeProductRepository(),
        locationProvider: () async => null,
      );
      const product = Product(
        id: 'p1',
        name: 'Mie Goreng',
        category: 'Makanan',
        price: 18000,
        description: '',
        iconName: 'ramen_dining',
      );

      provider.addToCart(product, quantity: 1);
      await provider.processCheckout(paidAmount: 20000, paymentMethod: 'Tunai');

      await tester.pumpWidget(buildTestApp(const HistoryScreen(), provider));
      await tester.pumpAndSettle();

      expect(find.text('Riwayat Transaksi'), findsOneWidget);
      expect(find.text('Rp 18000'), findsOneWidget);
      expect(find.textContaining('Tunai'), findsWidgets);
    });
  });
}

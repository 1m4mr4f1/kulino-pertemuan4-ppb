import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:warung_pos/main.dart';
import 'package:warung_pos/models/product.dart';
import 'package:warung_pos/models/transaction_record.dart';
import 'package:warung_pos/providers/pos_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('PosProvider Unit Tests', () {
    test('add to cart and calculate total correctly', () {
      final provider = PosProvider();
      const product = Product(
        id: 'test_1',
        name: 'Nasi Goreng Test',
        category: 'Makanan',
        price: 20000,
        description: 'Enak',
        iconName: 'fastfood',
      );

      provider.addToCart(product, quantity: 2);
      expect(provider.cart.length, 1);
      expect(provider.totalCartCount, 2);
      expect(provider.totalCartPrice, 40000);

      provider.updateQuantity(0, 3);
      expect(provider.totalCartCount, 3);
      expect(provider.totalCartPrice, 60000);

      provider.removeFromCart(0);
      expect(provider.cart.isEmpty, isTrue);
      expect(provider.totalCartPrice, 0);
    });

    test('model serialization and deserialization', () {
      const product = Product(
        id: 'p10',
        name: 'Kopi Susu',
        category: 'Minuman',
        price: 10000,
        description: 'Segar',
        iconName: 'coffee',
      );

      final json = product.toJson();
      final fromJson = Product.fromJson(json);
      expect(fromJson.id, product.id);
      expect(fromJson.name, product.name);
      expect(fromJson.price, product.price);

      final trx = TransactionRecord(
        id: 'TRX-TEST',
        timestamp: DateTime(2026, 1, 1),
        items: [],
        totalAmount: 10000,
        paidAmount: 10000,
        changeAmount: 0,
        paymentMethod: 'Tunai',
        latitude: -6.99,
        longitude: 110.42,
      );

      final trxJson = trx.toJson();
      final trxFromJson = TransactionRecord.fromJson(trxJson);
      expect(trxFromJson.id, trx.id);
      expect(trxFromJson.latitude, -6.99);
      expect(trxFromJson.longitude, 110.42);
    });
  });

  group('Widget Tests', () {
    testWidgets('WarungPosApp mounts and shows initial screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => PosProvider()..loadProducts(),
          child: const WarungPosApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('WarungPOS'), findsWidgets);
      expect(find.text('Semua'), findsOneWidget);
    });
  });
}

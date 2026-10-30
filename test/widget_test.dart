import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warung_pos/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('WarungPosApp basic render and load test', (WidgetTester tester) async {
    await tester.pumpWidget(const WarungPosApp());
    await tester.pumpAndSettle();
    expect(find.text('WarungPOS'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
  });
}

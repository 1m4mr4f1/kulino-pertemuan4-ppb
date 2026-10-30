import 'package:flutter_test/flutter_test.dart';
import 'package:warung_pos/main.dart';

void main() {
  testWidgets('WarungPosApp basic render test', (WidgetTester tester) async {
    await tester.pumpWidget(const WarungPosApp());
    expect(find.text('WarungPOS'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
  });
}

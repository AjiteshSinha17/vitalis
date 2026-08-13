import 'package:flutter_test/flutter_test.dart';
import 'package:vitalis/main.dart';

void main() {
  testWidgets('Vitalis app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VitalisApp());
    expect(find.byType(VitalisApp), findsOneWidget);
  });
}

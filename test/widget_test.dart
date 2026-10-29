import 'package:flutter_test/flutter_test.dart';
import 'package:gt_baby/main.dart';

void main() {
  testWidgets('BabyOS smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BabyOsApp());
    expect(find.text('INICIAR DEPLOY'), findsOneWidget);
  });
}

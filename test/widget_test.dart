import 'package:app2_checkers/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the checkers shell', (tester) async {
    await tester.pumpWidget(const CheckersApp());

    expect(find.text('CHECKERS'), findsOneWidget);
    expect(find.text('Game board coming next'), findsOneWidget);
  });
}

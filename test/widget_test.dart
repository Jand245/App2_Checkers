import 'package:app2_checkers/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows an 8 by 8 checkers board', (tester) async {
    await tester.pumpWidget(const CheckersApp());

    expect(find.text('CHECKERS'), findsOneWidget);
    expect(find.byKey(const Key('checkers-board')), findsOneWidget);

    for (var index = 0; index < 64; index++) {
      expect(find.byKey(Key('board-square-$index')), findsOneWidget);
    }

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CheckersPiece &&
            widget.color == CheckersPieceColor.dark,
      ),
      findsNWidgets(12),
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CheckersPiece && widget.color == CheckersPieceColor.red,
      ),
      findsNWidgets(12),
    );
  });
}

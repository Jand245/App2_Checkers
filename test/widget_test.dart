import 'package:app2_checkers/main.dart';
import 'package:flutter/material.dart';
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

  testWidgets('moves pieces diagonally and alternates turns', (tester) async {
    await tester.pumpWidget(const CheckersApp());

    await tester.tap(find.byKey(const Key('board-square-40')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-33')), findsNothing);

    await tester.tap(find.byKey(const Key('board-square-17')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-24')), findsOneWidget);
    expect(find.byKey(const Key('move-target-26')), findsOneWidget);

    await tester.tap(find.byKey(const Key('board-square-24')));
    await tester.pump();
    expect(find.byKey(const Key('piece-17')), findsNothing);
    expect(find.byKey(const Key('piece-24')), findsOneWidget);
    expect(find.byKey(const Key('move-target-24')), findsNothing);
    expect(find.byKey(const Key('move-target-26')), findsNothing);

    await tester.tap(find.byKey(const Key('board-square-24')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-17')), findsNothing);

    await tester.tap(find.byKey(const Key('board-square-40')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-33')), findsOneWidget);
  });
}

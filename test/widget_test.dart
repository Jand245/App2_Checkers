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

  testWidgets('jumps over and removes an opposing piece', (tester) async {
    await tester.pumpWidget(const CheckersApp());

    await tester.tap(find.byKey(const Key('board-square-17')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('board-square-26')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('board-square-40')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('board-square-33')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('board-square-26')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-40')), findsOneWidget);

    await tester.tap(find.byKey(const Key('board-square-40')));
    await tester.pump();

    expect(find.byKey(const Key('piece-26')), findsNothing);
    expect(find.byKey(const Key('piece-33')), findsNothing);
    expect(find.byKey(const Key('piece-40')), findsOneWidget);

    await tester.tap(find.byKey(const Key('board-square-42')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-35')), findsOneWidget);
  });

  testWidgets('winning screen shows the winner and replays', (tester) async {
    var replayPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: CheckersWinningScreen(
          winner: CheckersPieceColor.red,
          onReplay: () => replayPressed = true,
        ),
      ),
    );

    expect(find.byKey(const Key('winning-screen')), findsOneWidget);
    expect(find.text('Red wins!'), findsOneWidget);
    expect(find.text('PLAY AGAIN'), findsOneWidget);

    await tester.tap(find.byKey(const Key('replay-button')));
    expect(replayPressed, isTrue);
  });
}

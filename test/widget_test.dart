import 'package:app2_checkers/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> startGame(WidgetTester tester) async {
    await tester.enterText(find.byKey(const Key('dark-player-name')), 'Alex');
    await tester.enterText(find.byKey(const Key('red-player-name')), 'Jordan');
    await tester.tap(find.byKey(const Key('start-game-button')));
    await tester.pump();
  }

  Future<void> startCpuGame(WidgetTester tester) async {
    await tester.tap(find.text('VS CPU'));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('dark-player-name')), 'Alex');
    await tester.tap(find.byKey(const Key('start-game-button')));
    await tester.pump();
  }

  testWidgets('collects player names before starting the game', (tester) async {
    await tester.pumpWidget(const CheckersApp());

    expect(find.byKey(const Key('player-setup')), findsOneWidget);
    expect(find.byKey(const Key('checkers-board')), findsNothing);

    await startGame(tester);

    expect(find.byKey(const Key('player-setup')), findsNothing);
    expect(find.byKey(const Key('checkers-board')), findsOneWidget);
    expect(find.text('Alex: 0'), findsOneWidget);
    expect(find.text('Jordan: 0'), findsOneWidget);
  });

  testWidgets('selects a CPU opponent before starting the game', (
    tester,
  ) async {
    await tester.pumpWidget(const CheckersApp());

    expect(find.byKey(const Key('game-mode-selector')), findsOneWidget);
    expect(find.byKey(const Key('red-player-name')), findsOneWidget);

    await tester.tap(find.text('VS CPU'));
    await tester.pump();

    expect(find.byKey(const Key('red-player-name')), findsNothing);
    expect(find.byKey(const Key('cpu-opponent-label')), findsOneWidget);
    expect(find.text('Red player: CPU'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('dark-player-name')), 'Alex');
    await tester.tap(find.byKey(const Key('start-game-button')));
    await tester.pump();

    expect(find.text('Alex: 0'), findsOneWidget);
    expect(find.text('CPU: 0'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CheckersBoard && widget.gameMode == GameMode.vsCpu,
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows an 8 by 8 checkers board', (tester) async {
    await tester.pumpWidget(const CheckersApp());
    await startGame(tester);

    expect(find.text('CHECKERS'), findsOneWidget);
    expect(find.byKey(const Key('checkers-board')), findsOneWidget);

    for (var index = 0; index < 64; index++) {
      expect(find.byKey(Key('board-square-$index')), findsOneWidget);
    }

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CheckersPiece && widget.color == CheckersPieceColor.dark,
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
    await startGame(tester);

    expect(find.byKey(const Key('black-turn')), findsOneWidget);
    expect(find.text('BLACK TURN'), findsOneWidget);
    expect(find.byKey(const Key('red-turn')), findsNothing);

    await tester.tap(find.byKey(const Key('board-square-40')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-33')), findsNothing);

    await tester.tap(find.byKey(const Key('board-square-17')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-24')), findsOneWidget);
    expect(find.byKey(const Key('move-target-26')), findsOneWidget);

    await tester.tap(find.byKey(const Key('board-square-24')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byKey(const Key('piece-17')), findsNothing);
    expect(find.byKey(const Key('piece-24')), findsOneWidget);
    expect(find.byKey(const Key('move-target-24')), findsNothing);
    expect(find.byKey(const Key('move-target-26')), findsNothing);
    expect(find.byKey(const Key('red-turn')), findsOneWidget);
    expect(find.text('RED TURN'), findsOneWidget);
    expect(find.byKey(const Key('black-turn')), findsNothing);

    await tester.tap(find.byKey(const Key('board-square-24')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-17')), findsNothing);

    await tester.tap(find.byKey(const Key('board-square-40')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-33')), findsOneWidget);
  });

  testWidgets('jumps over and removes an opposing piece', (tester) async {
    await tester.pumpWidget(const CheckersApp());
    await startGame(tester);

    await tester.tap(find.byKey(const Key('board-square-17')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('board-square-26')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('board-square-40')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('board-square-33')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('board-square-19')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-28')), findsNothing);

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

  testWidgets('CPU chooses and completes a red move', (tester) async {
    await tester.pumpWidget(const CheckersApp());
    await startCpuGame(tester);

    await tester.tap(find.byKey(const Key('board-square-17')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('board-square-24')));
    await tester.pump();

    expect(find.byKey(const Key('cpu-thinking-indicator')), findsOneWidget);
    expect(find.text('CPU thinking…'), findsOneWidget);

    await tester.tap(find.byKey(const Key('board-square-40')));
    await tester.pump();
    expect(find.byKey(const Key('move-target-33')), findsNothing);

    int cpuPiecesAdvanced() => [33, 35, 37, 39]
        .where((index) => find.byKey(Key('piece-$index')).evaluate().isNotEmpty)
        .length;

    await tester.pump(const Duration(milliseconds: 900));

    expect(find.byKey(const Key('cpu-thinking-indicator')), findsOneWidget);
    expect(cpuPiecesAdvanced(), 0);

    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byKey(const Key('cpu-thinking-indicator')), findsNothing);
    expect(cpuPiecesAdvanced(), 1);

    await tester.tap(find.byKey(const Key('board-square-19')));
    await tester.pump();
    expect(
      find.byKey(const Key('move-target-26')).evaluate().isNotEmpty ||
          find.byKey(const Key('move-target-28')).evaluate().isNotEmpty,
      isTrue,
    );
  });

  testWidgets('winning screen shows the winner and replays', (tester) async {
    var replayPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: CheckersWinningScreen(
          winner: CheckersPieceColor.red,
          onReplay: () => replayPressed = true,
          darkPlayerName: 'Alex',
          redPlayerName: 'Jordan',
          darkScore: 1,
          redScore: 2,
        ),
      ),
    );

    expect(find.byKey(const Key('winning-screen')), findsOneWidget);
    expect(find.text('Jordan wins!'), findsOneWidget);
    expect(find.text('Alex: 1'), findsOneWidget);
    expect(find.text('Jordan: 2'), findsOneWidget);
    expect(find.text('PLAY AGAIN'), findsOneWidget);

    await tester.tap(find.byKey(const Key('replay-button')));
    expect(replayPressed, isTrue);
  });
}

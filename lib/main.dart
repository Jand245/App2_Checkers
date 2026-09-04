import 'package:flutter/material.dart';

void main() {
  runApp(const CheckersApp());
}

class CheckersApp extends StatelessWidget {
  const CheckersApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF7B2D26);

    return MaterialApp(
      title: 'Checkers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F1E5),
        appBarTheme: const AppBarTheme(
          backgroundColor: seedColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

enum GameMode { twoPlayers, vsCpu }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _darkPlayerController = TextEditingController();
  final _redPlayerController = TextEditingController();
  GameMode _gameMode = GameMode.twoPlayers;
  bool _gameStarted = false;

  @override
  void dispose() {
    _darkPlayerController.dispose();
    _redPlayerController.dispose();
    super.dispose();
  }

  void _startGame() {
    FocusScope.of(context).unfocus();
    setState(() => _gameStarted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CHECKERS')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(_gameStarted ? 0 : 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: _gameStarted ? double.infinity : 520,
              ),
              child: _gameStarted
                  ? SizedBox.expand(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8D7B7),
                          border: Border.all(
                            color: const Color(0xFF4A2C23),
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          child: CheckersBoard(
                            darkPlayerName: _darkPlayerController.text.trim(),
                            redPlayerName: _gameMode == GameMode.vsCpu
                                ? 'CPU'
                                : _redPlayerController.text.trim(),
                            gameMode: _gameMode,
                          ),
                        ),
                      ),
                    )
                  : Card(
                      key: const Key('player-setup'),
                      elevation: 10,
                      color: const Color(0xFFE8D7B7),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.sports_esports,
                              size: 72,
                              color: Color(0xFF7B2D26),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'READY TO PLAY?',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            SegmentedButton<GameMode>(
                              key: const Key('game-mode-selector'),
                              showSelectedIcon: false,
                              segments: const [
                                ButtonSegment(
                                  value: GameMode.twoPlayers,
                                  icon: Icon(Icons.people),
                                  label: Text('2 PLAYERS'),
                                ),
                                ButtonSegment(
                                  value: GameMode.vsCpu,
                                  icon: Icon(Icons.computer),
                                  label: Text('VS CPU'),
                                ),
                              ],
                              selected: {_gameMode},
                              onSelectionChanged: (selection) {
                                FocusScope.of(context).unfocus();
                                setState(() => _gameMode = selection.first);
                              },
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              key: const Key('dark-player-name'),
                              controller: _darkPlayerController,
                              textInputAction: _gameMode == GameMode.twoPlayers
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              onSubmitted: _gameMode == GameMode.vsCpu
                                  ? (_) => _startGame()
                                  : null,
                              decoration: const InputDecoration(
                                labelText: 'Black player name',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_gameMode == GameMode.twoPlayers)
                              TextField(
                                key: const Key('red-player-name'),
                                controller: _redPlayerController,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _startGame(),
                                decoration: const InputDecoration(
                                  labelText: 'Red player name',
                                  prefixIcon: Icon(Icons.person_outline),
                                  border: OutlineInputBorder(),
                                ),
                              )
                            else
                              Container(
                                key: const Key('cpu-opponent-label'),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.computer),
                                    SizedBox(width: 12),
                                    Text('Red player: CPU'),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 28),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                key: const Key('start-game-button'),
                                onPressed: _startGame,
                                icon: const Icon(Icons.play_arrow),
                                label: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Text('START GAME'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class CheckersBoard extends StatefulWidget {
  const CheckersBoard({
    this.darkPlayerName = 'Black',
    this.redPlayerName = 'Red',
    this.gameMode = GameMode.twoPlayers,
    super.key,
  });

  final String darkPlayerName;
  final String redPlayerName;
  final GameMode gameMode;

  @override
  State<CheckersBoard> createState() => _CheckersBoardState();
}

class _CheckersBoardState extends State<CheckersBoard> {
  static const _lightSquareColor = Color(0xFFE8D7B7);
  static const _darkSquareColor = Color(0xFF7B2D26);

  late final List<CheckersPieceColor?> _squares;
  final Set<int> _kings = {};
  CheckersPieceColor _currentPlayer = CheckersPieceColor.dark;
  int? _selectedIndex;
  bool _mustContinueCapture = false;
  bool _isCpuThinking = false;
  bool _cpuMoveScheduled = false;
  CheckersPieceColor? _winner;
  int _darkScore = 0;
  int _redScore = 0;

  @override
  void initState() {
    super.initState();
    _squares = List.generate(64, _startingPieceAt);
  }

  @override
  Widget build(BuildContext context) {
    final legalMoves = _legalMovesFrom(_selectedIndex);

    if (_winner != null) {
      return CheckersWinningScreen(
        winner: _winner!,
        onReplay: _replay,
        darkPlayerName: _darkPlayerName,
        redPlayerName: _redPlayerName,
        darkScore: _darkScore,
        redScore: _redScore,
      );
    }

    return Column(
      children: [
        _ScoreKeeper(
          darkPlayerName: _darkPlayerName,
          redPlayerName: _redPlayerName,
          darkScore: _darkScore,
          redScore: _redScore,
          statusMessage: _isCpuThinking ? 'CPU thinking…' : null,
        ),
        _TurnIndicator(currentPlayer: _currentPlayer),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                key: const Key('checkers-board'),
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: 64,
                itemBuilder: (context, index) {
                  final row = index ~/ 8;
                  final column = index % 8;
                  final isDarkSquare = (row + column).isOdd;
                  final pieceColor = _squares[index];

                  return GestureDetector(
                    key: Key('board-square-$index'),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _handleSquareTap(index, legalMoves),
                    child: ColoredBox(
                      color: isDarkSquare
                          ? _darkSquareColor
                          : _lightSquareColor,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (pieceColor != null)
                            Center(
                              child: CheckersPiece(
                                key: Key('piece-$index'),
                                color: pieceColor,
                              ),
                            ),
                          if (pieceColor != null && _kings.contains(index))
                            const Center(
                              child: Icon(
                                Icons.workspace_premium,
                                key: Key('king-crown'),
                                color: Color(0xFFFFD166),
                              ),
                            ),
                          if (legalMoves.contains(index))
                            Center(
                              child: FractionallySizedBox(
                                widthFactor: 0.28,
                                heightFactor: 0.28,
                                child: DecoratedBox(
                                  key: Key('move-target-$index'),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFD166),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x66000000),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  String get _darkPlayerName =>
      widget.darkPlayerName.isEmpty ? 'Black' : widget.darkPlayerName;

  String get _redPlayerName =>
      widget.redPlayerName.isEmpty ? 'Red' : widget.redPlayerName;

  bool get _isCpuGame => widget.gameMode == GameMode.vsCpu;

  CheckersPieceColor? _startingPieceAt(int index) {
    final row = index ~/ 8;
    final column = index % 8;

    if ((row + column).isEven) {
      return null;
    }
    if (row < 3) {
      return CheckersPieceColor.dark;
    }
    if (row > 4) {
      return CheckersPieceColor.red;
    }
    return null;
  }

  Set<int> _legalMovesFrom(int? index) {
    if (index == null) {
      return const {};
    }

    final pieceColor = _squares[index];
    if (pieceColor == null) {
      return const {};
    }

    if (_mustContinueCapture) {
      return index == _selectedIndex ? _captureMovesFrom(index) : const {};
    }

    return _legalMovesFor(pieceColor)
        .where((move) => move.source == index)
        .map((move) => move.destination)
        .toSet();
  }

  List<_CheckersMove> _legalMovesFor(
    CheckersPieceColor player, {
    int? onlySource,
  }) {
    final sourceIndices = Iterable<int>.generate(64).where(
      (index) =>
          _squares[index] == player &&
          (onlySource == null || index == onlySource),
    );
    final captureMoves = <_CheckersMove>[];

    for (final source in sourceIndices) {
      for (final destination in _captureMovesFrom(source)) {
        captureMoves.add(_CheckersMove(source, destination));
      }
    }

    if (captureMoves.isNotEmpty || onlySource != null) {
      return captureMoves;
    }

    final regularMoves = <_CheckersMove>[];
    for (final source in sourceIndices) {
      for (final destination in _regularMovesFrom(source)) {
        regularMoves.add(_CheckersMove(source, destination));
      }
    }
    return regularMoves;
  }

  Set<int> _regularMovesFrom(
    int index, {
    List<CheckersPieceColor?>? squares,
    Set<int>? kings,
  }) {
    final board = squares ?? _squares;
    final crownedPieces = kings ?? _kings;
    final pieceColor = board[index];
    if (pieceColor == null) {
      return const {};
    }

    final row = index ~/ 8;
    final column = index % 8;
    if (crownedPieces.contains(index)) {
      final kingMoves = <int>{};
      for (final kingRowDirection in const [-1, 1]) {
        final kingDestinationRow = row + kingRowDirection;
        if (kingDestinationRow < 0 || kingDestinationRow >= 8) continue;

        for (final columnDirection in const [-1, 1]) {
          final destinationColumn = column + columnDirection;
          if (destinationColumn < 0 || destinationColumn >= 8) continue;

          final destinationIndex = kingDestinationRow * 8 + destinationColumn;
          if (board[destinationIndex] == null) {
            kingMoves.add(destinationIndex);
          }
        }
      }
      return kingMoves;
    }

    final rowDirection = pieceColor == CheckersPieceColor.dark ? 1 : -1;
    final destinationRow = row + rowDirection;
    final legalMoves = <int>{};

    if (destinationRow < 0 || destinationRow >= 8) {
      return legalMoves;
    }

    for (final columnDirection in const [-1, 1]) {
      final destinationColumn = column + columnDirection;
      if (destinationColumn < 0 || destinationColumn >= 8) {
        continue;
      }

      final destinationIndex = destinationRow * 8 + destinationColumn;
      if (board[destinationIndex] == null) {
        legalMoves.add(destinationIndex);
      }
    }

    return legalMoves;
  }

  Set<int> _captureMovesFrom(
    int index, {
    List<CheckersPieceColor?>? squares,
    Set<int>? kings,
  }) {
    final board = squares ?? _squares;
    final crownedPieces = kings ?? _kings;
    final pieceColor = board[index];
    if (pieceColor == null) {
      return const {};
    }

    final row = index ~/ 8;
    final column = index % 8;
    if (crownedPieces.contains(index)) {
      final kingCaptureMoves = <int>{};
      for (final kingRowDirection in const [-1, 1]) {
        final kingLandingRow = row + kingRowDirection * 2;
        if (kingLandingRow < 0 || kingLandingRow >= 8) continue;

        for (final columnDirection in const [-1, 1]) {
          final middleColumn = column + columnDirection;
          final landingColumn = column + columnDirection * 2;
          if (landingColumn < 0 || landingColumn >= 8) continue;

          final middleIndex = (row + kingRowDirection) * 8 + middleColumn;
          final landingIndex = kingLandingRow * 8 + landingColumn;
          final jumpedPiece = board[middleIndex];
          if (jumpedPiece != null &&
              jumpedPiece != pieceColor &&
              board[landingIndex] == null) {
            kingCaptureMoves.add(landingIndex);
          }
        }
      }
      return kingCaptureMoves;
    }

    final rowDirection = pieceColor == CheckersPieceColor.dark ? 1 : -1;
    final landingRow = row + rowDirection * 2;
    final captureMoves = <int>{};

    if (landingRow < 0 || landingRow >= 8) {
      return captureMoves;
    }

    for (final columnDirection in const [-1, 1]) {
      final middleColumn = column + columnDirection;
      final landingColumn = column + columnDirection * 2;
      if (landingColumn < 0 || landingColumn >= 8) {
        continue;
      }

      final middleIndex = (row + rowDirection) * 8 + middleColumn;
      final landingIndex = landingRow * 8 + landingColumn;
      final jumpedPiece = board[middleIndex];
      if (jumpedPiece != null &&
          jumpedPiece != pieceColor &&
          board[landingIndex] == null) {
        captureMoves.add(landingIndex);
      }
    }

    return captureMoves;
  }

  void _handleSquareTap(int index, Set<int> legalMoves) {
    if (_isCpuGame &&
        (_currentPlayer == CheckersPieceColor.red || _isCpuThinking)) {
      return;
    }

    final pieceColor = _squares[index];

    if (pieceColor == _currentPlayer) {
      if (_mustContinueCapture) {
        return;
      }
      final playerMustCapture = _legalMovesFor(
        _currentPlayer,
      ).any((move) => move.isCapture);
      if (playerMustCapture && _captureMovesFrom(index).isEmpty) {
        return;
      }
      setState(() {
        _selectedIndex = _selectedIndex == index ? null : index;
      });
      return;
    }

    if (_selectedIndex != null && legalMoves.contains(index)) {
      var shouldStartCpuTurn = false;
      setState(() {
        final sourceIndex = _selectedIndex!;
        if (_applyMove(sourceIndex, index)) {
          _finishTurn();
          shouldStartCpuTurn =
              _isCpuGame &&
              _winner == null &&
              _currentPlayer == CheckersPieceColor.red;
        }
      });
      if (shouldStartCpuTurn) {
        _scheduleCpuTurn();
      }
    }
  }

  bool _applyMove(int sourceIndex, int destinationIndex) {
    final move = _CheckersMove(sourceIndex, destinationIndex);
    final movingPiece = _squares[sourceIndex]!;
    final wasKing = _kings.remove(sourceIndex);

    _squares[destinationIndex] = movingPiece;
    _squares[sourceIndex] = null;

    final destinationRow = destinationIndex ~/ 8;
    final wasPromoted =
        !wasKing &&
        ((movingPiece == CheckersPieceColor.dark && destinationRow == 7) ||
            (movingPiece == CheckersPieceColor.red && destinationRow == 0));
    if (wasKing || wasPromoted) {
      _kings.add(destinationIndex);
    }

    if (move.isCapture) {
      final jumpedIndex = move.jumpedIndex;
      _squares[jumpedIndex] = null;
      _kings.remove(jumpedIndex);

      if (!wasPromoted && _captureMovesFrom(destinationIndex).isNotEmpty) {
        _selectedIndex = destinationIndex;
        _mustContinueCapture = true;
        return false;
      }
    }

    _selectedIndex = null;
    _mustContinueCapture = false;
    return true;
  }

  void _finishTurn() {
    _selectedIndex = null;
    _mustContinueCapture = false;
    _currentPlayer = _currentPlayer == CheckersPieceColor.dark
        ? CheckersPieceColor.red
        : CheckersPieceColor.dark;
    _checkForWinner();
  }

  void _scheduleCpuTurn() {
    if (!_isCpuGame ||
        _winner != null ||
        _currentPlayer != CheckersPieceColor.red ||
        _cpuMoveScheduled) {
      return;
    }

    _cpuMoveScheduled = true;
    if (!_isCpuThinking) {
      setState(() => _isCpuThinking = true);
    }

    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _cpuMoveScheduled = false;
      if (!_isCpuGame ||
          _winner != null ||
          _currentPlayer != CheckersPieceColor.red ||
          !_isCpuThinking) {
        return;
      }
      _makeCpuMove();
    });
  }

  void _makeCpuMove() {
    final moves = _legalMovesFor(
      CheckersPieceColor.red,
      onlySource: _mustContinueCapture ? _selectedIndex : null,
    );

    if (moves.isEmpty) {
      setState(() {
        _isCpuThinking = false;
        _checkForWinner();
      });
      return;
    }

    final move = _chooseCpuMove(moves);
    var mustContinue = false;
    setState(() {
      _selectedIndex = move.source;
      if (_applyMove(move.source, move.destination)) {
        _finishTurn();
        _isCpuThinking = false;
      } else {
        mustContinue = true;
      }
    });

    if (mustContinue) {
      _scheduleCpuTurn();
    }
  }

  _CheckersMove _chooseCpuMove(List<_CheckersMove> moves) {
    var bestMove = moves.first;
    var bestScore = _scoreCpuMove(bestMove);

    for (final move in moves.skip(1)) {
      final score = _scoreCpuMove(move);
      final winsTie =
          score == bestScore &&
          (move.source < bestMove.source ||
              (move.source == bestMove.source &&
                  move.destination < bestMove.destination));
      if (score > bestScore || winsTie) {
        bestMove = move;
        bestScore = score;
      }
    }
    return bestMove;
  }

  int _scoreCpuMove(_CheckersMove move) {
    final board = List<CheckersPieceColor?>.of(_squares);
    final crownedPieces = Set<int>.of(_kings);
    final movingPiece = board[move.source]!;
    final wasKing = crownedPieces.remove(move.source);

    board[move.destination] = movingPiece;
    board[move.source] = null;
    if (move.isCapture) {
      board[move.jumpedIndex] = null;
      crownedPieces.remove(move.jumpedIndex);
    }

    final destinationRow = move.destination ~/ 8;
    final destinationColumn = move.destination % 8;
    final wasPromoted =
        !wasKing &&
        movingPiece == CheckersPieceColor.red &&
        destinationRow == 0;
    if (wasKing || wasPromoted) {
      crownedPieces.add(move.destination);
    }

    var score = 0;
    if (move.isCapture) score += 100;
    if (wasPromoted) score += 75;
    if (move.isCapture && !wasPromoted) {
      score +=
          _captureMovesFrom(
            move.destination,
            squares: board,
            kings: crownedPieces,
          ).length *
          35;
    }

    if (_isImmediatelyCapturable(move.destination, board, crownedPieces)) {
      score -= 60;
    }

    score += 7 - (destinationColumn * 2 - 7).abs();
    score += 7 - destinationRow;
    if (destinationColumn == 0 || destinationColumn == 7) score += 4;
    score += _regularMovesFrom(
      move.destination,
      squares: board,
      kings: crownedPieces,
    ).length;

    return score;
  }

  bool _isImmediatelyCapturable(
    int targetIndex,
    List<CheckersPieceColor?> board,
    Set<int> crownedPieces,
  ) {
    for (var source = 0; source < 64; source++) {
      if (board[source] != CheckersPieceColor.dark) continue;
      for (final destination in _captureMovesFrom(
        source,
        squares: board,
        kings: crownedPieces,
      )) {
        final response = _CheckersMove(source, destination);
        if (response.jumpedIndex == targetIndex) {
          return true;
        }
      }
    }
    return false;
  }

  void _checkForWinner() {
    final currentPlayerHasPieces = _squares.contains(_currentPlayer);
    final currentPlayerCanMove = _legalMovesFor(_currentPlayer).isNotEmpty;

    if (!currentPlayerHasPieces || !currentPlayerCanMove) {
      _winner = _currentPlayer == CheckersPieceColor.dark
          ? CheckersPieceColor.red
          : CheckersPieceColor.dark;
      if (_winner == CheckersPieceColor.dark) {
        _darkScore++;
      } else {
        _redScore++;
      }
    }
  }

  void _replay() {
    setState(() {
      for (var index = 0; index < 64; index++) {
        _squares[index] = _startingPieceAt(index);
      }
      _kings.clear();
      _currentPlayer = CheckersPieceColor.dark;
      _selectedIndex = null;
      _mustContinueCapture = false;
      _isCpuThinking = false;
      _cpuMoveScheduled = false;
      _winner = null;
    });
  }
}

class _CheckersMove {
  const _CheckersMove(this.source, this.destination);

  final int source;
  final int destination;

  bool get isCapture => (destination ~/ 8 - source ~/ 8).abs() == 2;

  int get jumpedIndex =>
      ((source ~/ 8 + destination ~/ 8) ~/ 2) * 8 +
      ((source % 8 + destination % 8) ~/ 2);
}

enum CheckersPieceColor { dark, red }

class CheckersPiece extends StatelessWidget {
  const CheckersPiece({required this.color, super.key});

  final CheckersPieceColor color;

  @override
  Widget build(BuildContext context) {
    final colors = switch (color) {
      CheckersPieceColor.dark => const [Color(0xFF4A4542), Color(0xFF1F1C1B)],
      CheckersPieceColor.red => const [Color(0xFFED6658), Color(0xFFB72F27)],
    };

    return FractionallySizedBox(
      widthFactor: 0.72,
      heightFactor: 0.72,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          border: Border.all(color: colors.last, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x55000000),
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckersWinningScreen extends StatelessWidget {
  const CheckersWinningScreen({
    required this.winner,
    required this.onReplay,
    this.darkPlayerName = 'Black',
    this.redPlayerName = 'Red',
    this.darkScore = 0,
    this.redScore = 0,
    super.key,
  });

  final CheckersPieceColor winner;
  final VoidCallback onReplay;
  final String darkPlayerName;
  final String redPlayerName;
  final int darkScore;
  final int redScore;

  @override
  Widget build(BuildContext context) {
    final winnerName = winner == CheckersPieceColor.dark
        ? darkPlayerName
        : redPlayerName;
    final winnerColor = winner == CheckersPieceColor.dark
        ? const Color(0xFF1F1C1B)
        : const Color(0xFFB72F27);

    return ColoredBox(
      key: const Key('winning-screen'),
      color: const Color(0xFFE8D7B7),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events, size: 88, color: winnerColor),
              const SizedBox(height: 16),
              Text(
                '$winnerName wins!',
                key: const Key('winner-message'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: winnerColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _ScoreKeeper(
                darkPlayerName: darkPlayerName,
                redPlayerName: redPlayerName,
                darkScore: darkScore,
                redScore: redScore,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                key: const Key('replay-button'),
                onPressed: onReplay,
                icon: const Icon(Icons.replay),
                label: const Text('PLAY AGAIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TurnIndicator extends StatelessWidget {
  const _TurnIndicator({required this.currentPlayer});

  final CheckersPieceColor currentPlayer;

  @override
  Widget build(BuildContext context) {
    final isBlackTurn = currentPlayer == CheckersPieceColor.dark;
    final indicatorColor = isBlackTurn
        ? const Color(0xFF1F1C1B)
        : const Color(0xFFB72F27);

    return AnimatedContainer(
      key: const Key('turn-indicator'),
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: indicatorColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          isBlackTurn ? 'BLACK TURN' : 'RED TURN',
          key: Key(isBlackTurn ? 'black-turn' : 'red-turn'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

class _ScoreKeeper extends StatelessWidget {
  const _ScoreKeeper({
    required this.darkPlayerName,
    required this.redPlayerName,
    required this.darkScore,
    required this.redScore,
    this.statusMessage,
  });

  final String darkPlayerName;
  final String redPlayerName;
  final int darkScore;
  final int redScore;
  final String? statusMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('score-keeper'),
      color: const Color(0xFFF7F1E5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$darkPlayerName: $darkScore',
                  key: const Key('dark-score'),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Text('  —  '),
              Expanded(
                child: Text(
                  '$redPlayerName: $redScore',
                  key: const Key('red-score'),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFB72F27),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (statusMessage != null)
            Container(
              key: const Key('cpu-thinking-indicator'),
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0x33FFD166),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.computer,
                    size: 18,
                    color: Color(0xFF7B2D26),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusMessage!,
                    style: const TextStyle(
                      color: Color(0xFF4A2C23),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

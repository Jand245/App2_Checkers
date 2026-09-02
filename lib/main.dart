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

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHECKERS'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: AspectRatio(
                aspectRatio: 1,
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
                  child: const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: CheckersBoard(),
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

class CheckersBoard extends StatelessWidget {
  const CheckersBoard({super.key});

  static const _lightSquareColor = Color(0xFFE8D7B7);
  static const _darkSquareColor = Color(0xFF7B2D26);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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

        return ColoredBox(
          key: Key('board-square-$index'),
          color: isDarkSquare ? _darkSquareColor : _lightSquareColor,
        );
      },
    );
  }
}

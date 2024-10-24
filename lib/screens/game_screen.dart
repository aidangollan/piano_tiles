import 'package:flutter/material.dart';
import 'dart:async';
import '../models/tile.dart';
import '../widgets/game_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Tile> tiles = [];
  Timer? gameTimer;
  int score = 0;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    tiles.clear();
    score = 0;
    isGameOver = false;
    
    // Create initial tiles
    addNewTile();

    // Start game loop
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (isGameOver) {
        timer.cancel();
        return;
      }

      setState(() {
        // Move existing tiles
        for (var tile in tiles) {
          tile.move(2.0); // Adjust speed as needed
          
          // Check if tile went off screen
          if (tile.yPosition > MediaQuery.of(context).size.height && !tile.isPressed) {
            tile.missed = true;
            isGameOver = true;
          }
        }

        // Remove pressed or off-screen tiles
        tiles.removeWhere((tile) => 
          tile.isPressed || tile.yPosition > MediaQuery.of(context).size.height);

        // Add new tiles periodically
        if (tiles.isEmpty || 
            tiles.last.yPosition > 200) { // Adjust spacing as needed
          addNewTile();
        }
      });
    });
  }

  void addNewTile() {
    final random = DateTime.now().millisecondsSinceEpoch % 4;
    tiles.add(Tile(lane: random, yPosition: -100));
  }

  void onTileTap(int lane) {
    if (isGameOver) return;

    setState(() {
      for (var tile in tiles) {
        if (tile.lane == lane && !tile.isPressed) {
          if (tile.yPosition > 0 && tile.yPosition < MediaQuery.of(context).size.height - 100) {
            tile.isPressed = true;
            score++;
            return;
          }
        }
      }
      // Missed tile - game over
      isGameOver = true;
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Score: $score'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: GameBoard(
              tiles: tiles,
              onTileTap: onTileTap,
              height: MediaQuery.of(context).size.height - 100,
            ),
          ),
          if (isGameOver)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text('Game Over! Score: $score',
                      style: const TextStyle(fontSize: 24)),
                  ElevatedButton(
                    onPressed: () => setState(() => startGame()),
                    child: const Text('Play Again'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/note.dart';
import '../models/level.dart';
import '../services/level_loader.dart';
import '../widgets/game_board.dart';

class GameScreen extends StatefulWidget {
  final String levelPath;
  
  const GameScreen({super.key, required this.levelPath});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Level? level;
  List<Note> activeNotes = [];
  Timer? gameTimer;
  int score = 0;
  bool isGameOver = false;
  double gameTime = 0;
  double _lastUpdateTime = 0;

  @override
  void initState() {
    super.initState();
    _loadLevel();
  }

  Future<void> _loadLevel() async {
    try {
      level = await LevelLoader.loadLevel(widget.levelPath);
      startGame();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to load level: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void startGame() {
    activeNotes.clear();
    score = 0;
    isGameOver = false;
    gameTime = 0;
    _lastUpdateTime = 0;

    // Start game loop
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (isGameOver || level == null) {
        timer.cancel();
        return;
      }

      setState(() {
        double currentTime = gameTime;
        double deltaTime = currentTime - _lastUpdateTime;
        _lastUpdateTime = currentTime;
        gameTime += 0.016; // 16ms in seconds

        // Add new notes based on start time
        for (var note in level!.notes) {
          if (note.startTime <= gameTime && 
              !activeNotes.contains(note) && 
              !note.isPressed) {
            activeNotes.add(note);
          }
        }

        // Check for missed notes
        for (var note in activeNotes) {
          if (gameTime > note.startTime + 1.0 && !note.isPressed) {
            note.missed = true;
            isGameOver = true;
          }
        }

        // Remove completed notes
        activeNotes.removeWhere((note) => 
          note.isPressed || (gameTime > note.startTime + note.duration));
      });
    });
  }

  void onNoteTap(String key) {
    if (isGameOver) return;

    setState(() {
      for (var note in activeNotes) {
        if (note.key == key && !note.isPressed) {
          double notePosition = (gameTime - note.startTime);
          if (notePosition >= 0 && notePosition <= 1.0) {
            note.isPressed = true;
            score++;
            return;
          }
        }
      }
      // Missed note - game over
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
      body: level == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GameBoard(
                    notes: activeNotes,
                    onNoteTap: onNoteTap,
                    height: MediaQuery.of(context).size.height - 100,
                    gameTime: gameTime, // Add this parameter
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
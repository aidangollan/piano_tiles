import 'package:flutter/material.dart';
import '../models/note.dart';

class GameBoard extends StatelessWidget {
  final List<Note> notes;
  final Function(String) onNoteTap;
  final double height;
  final double gameTime;  // Add this parameter

  const GameBoard({
    super.key,
    required this.notes,
    required this.onNoteTap,
    required this.height,
    required this.gameTime,  // Add this parameter
  });

  int _getLaneIndex(String key) {
    switch (key.toUpperCase()) {
      case 'C': return 0;
      case 'D': return 1;
      case 'E': return 2;
      case 'F': return 3;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update note positions
    for (var note in notes) {
      note.updatePosition(gameTime, height, 300); // 300 is the fall speed in pixels per second
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: List.generate(4, (laneIndex) {
          return Expanded(
            child: GestureDetector(
              onTapDown: (_) => onNoteTap(getLaneKey(laneIndex)),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Stack(
                  children: notes
                      .where((note) => _getLaneIndex(note.key) == laneIndex)
                      .map((note) => Positioned(
                            left: 0,
                            right: 0,
                            top: note.yPosition,
                            child: Container(
                              height: note.isLong ? note.duration * 100 : 100,
                              color: note.isPressed
                                  ? Colors.grey
                                  : note.missed
                                      ? Colors.red
                                      : Colors.black,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String getLaneKey(int lane) {
    switch (lane) {
      case 0: return 'C';
      case 1: return 'D';
      case 2: return 'E';
      case 3: return 'F';
      default: return 'C';
    }
  }
}
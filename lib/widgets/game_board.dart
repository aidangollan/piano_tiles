import 'package:flutter/material.dart';
import '../models/tile.dart';

class GameBoard extends StatelessWidget {
  final List<Tile> tiles;
  final Function(int) onTileTap;
  final double height;

  const GameBoard({
    super.key,
    required this.tiles,
    required this.onTileTap,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: List.generate(4, (laneIndex) {
          return Expanded(
            child: GestureDetector(
              onTapDown: (_) => onTileTap(laneIndex),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Stack(
                  children: tiles
                      .where((tile) => tile.lane == laneIndex)
                      .map((tile) => Positioned(
                            left: 0,
                            right: 0,
                            top: tile.yPosition,
                            child: Container(
                              height: 100,
                              color: tile.isPressed
                                  ? Colors.grey
                                  : tile.missed
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
}
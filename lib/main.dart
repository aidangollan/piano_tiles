import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(const PianoTilesGame());
}

class PianoTilesGame extends StatelessWidget {
  const PianoTilesGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piano Tiles',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}
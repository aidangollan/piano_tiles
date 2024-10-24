import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/level.dart';

class LevelLoader {
  static Future<Level> loadLevel(String levelPath) async {
    try {
      final String jsonString = await rootBundle.loadString(levelPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return Level.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to load level: $e');
    }
  }
}
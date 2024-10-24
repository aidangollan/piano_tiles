import 'note.dart';

class Level {
  final int bpm;
  final String backgroundSong;
  final List<Note> notes;

  Level({
    required this.bpm,
    required this.backgroundSong,
    required this.notes,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      bpm: json['bpm'],
      backgroundSong: json['backgroundSong'],
      notes: (json['notes'] as List)
          .map((noteJson) => Note.fromJson(noteJson))
          .toList(),
    );
  }
}
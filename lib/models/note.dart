class Note {
  final String key;
  final double startTime;
  final double duration;
  final bool isLong;
  bool isPressed;
  bool missed;
  double yPosition; // Add this to track vertical position

  Note({
    required this.key,
    required this.startTime,
    required this.duration,
    this.isLong = false,
    this.isPressed = false,
    this.missed = false,
    this.yPosition = -100, // Start above the screen
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      key: json['key'],
      startTime: json['startTime'].toDouble(),
      duration: json['duration'].toDouble(),
      isLong: json['isLong'] ?? false,
    );
  }

  void updatePosition(double gameTime, double screenHeight, double speed) {
    // Calculate position based on time and speed
    double targetY = ((gameTime - startTime) * speed);
    yPosition = targetY;
  }
}
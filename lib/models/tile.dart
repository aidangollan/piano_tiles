class Tile {
  final int lane;
  double yPosition;
  bool isPressed;
  bool missed;

  Tile({
    required this.lane,
    this.yPosition = 0,
    this.isPressed = false,
    this.missed = false,
  });

  void move(double distance) {
    yPosition += distance;
  }
}
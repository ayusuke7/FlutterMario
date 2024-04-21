
enum Dir { left, right }

class HitBox {

  double x;
  double y;

  double width;
  double height;

  Vector velocity = Vector.zero;

  Dir dir;
  
  List<String> sprites;
  String? sprite;

  HitBox({
    required this.x,
    required this.y,
    required this.height,
    required this.width,
    this.dir = Dir.right,
    this.sprites = const [],
    this.sprite,
  });

  double get top => y;

  double get left => x;

  double get bottom => y + height;

  double get right => x + width;

  void changeDir() {
    dir = dir == Dir.left ? Dir.right : Dir.left;
  }

  bool collideWith(HitBox other) {
    // Verifica se as posições futuras se sobrepõem
    return (
      x + velocity.x < other.x + other.width &&
      x + velocity.x + width > other.x &&
      y + velocity.y < other.y + other.height &&
      y + velocity.y + height > other.y
    );
  }

  Colision collideWithSide(HitBox other) {
    Colision colisions = Colision();

    double nextX = x + velocity.x;
    double nextY = y + velocity.y;

    double otherNextX = other.x + other.velocity.x;
    double otherNextY = other.y + other.velocity.y;

    double dx = (nextX + width / 2) - (otherNextX + other.width / 2);
    double dy = (nextY + height / 2) - (otherNextY + other.height / 2);

    double combinedHalfWidths = (width / 2) + (other.width / 2);
    double combinedHalfHeights = (height / 2) + (other.height / 2);

    if (
      dx.abs() < combinedHalfWidths && 
      dy.abs() < combinedHalfHeights
    ) {
      double overlapX = combinedHalfWidths - dx.abs();
      double overlapY = combinedHalfHeights - dy.abs();

      if (overlapX >= overlapY) {
        if (dy > 0) {
          colisions.bottom = true;
        } else {
          colisions.top = true;
        }
      } else {
        if (dx > 0) {
          colisions.right = true;
        } else {
          colisions.left = true;
        }
      }
    }

    return colisions;

  }

  @override
  String toString() {
    return "LTRB: [$left, $top, $right, $bottom], V$velocity, WH: [$width, $height]";
  }
}

class Colision {
  
  bool top;
  bool bottom;
  bool left;
  bool right;

  Colision({
    this.top = false,
    this.bottom = false,
    this.left = false,
    this.right = false,
  });

  @override
  String toString() {
    return "TLBR: [$top, $left, $bottom, $right]";
  }
}

class Vector {
  double x;
  double y;

  Vector(this.x, this.y);

  @override
  String toString() {
    return "XY: [$x, $y]";
  }

  static Vector get zero => Vector(0, 0);

  factory Vector.all(double xy) => Vector(xy, xy);

}

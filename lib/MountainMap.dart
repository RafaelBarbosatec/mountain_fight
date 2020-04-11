import 'package:bonfire/bonfire.dart';

class MountainMap {
  static double tileSize = 15;
  static MapWorld map() {
    List<Tile> tileList = List();
    List.generate(30, (y) {
      List.generate(50, (x) {
        if (x == 5 && y >= 5 && y < 10) {
          tileList.add(
            Tile(
              'tiles/beira_left.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }
      });
    });
    return MapWorld(tileList);
  }

  static Position getPosition(int x, int y) {
    return Position(x * tileSize, y * tileSize);
  }
}

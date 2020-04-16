import 'package:bonfire/bonfire.dart';
import 'package:mountain_fight/main.dart';

class MountainMap {
  static MapWorld map() {
    List<Tile> tileList = List();
    List.generate(20, (y) {
      List.generate(100, (x) {
        bool n = false;

        if (x >= 5 && x <= 34 && y == 7) {
          n = true;
          tileList.add(
            Tile(
              'tile/generic-rpg-tile01.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }

        if (x >= 5 && x <= 33 && y == 8) {
          n = true;
          tileList.add(
            Tile(
              x % 2 == 0
                  ? 'tile/generic-rpg-tile02.png'
                  : 'tile/generic-rpg-tile04.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }
        if (x >= 5 && x <= 30 && y == 9) {
          n = true;
          tileList.add(
            Tile(
              'tile/generic-rpg-tile71.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }
        if (x >= 5 && x <= 30 && y == 10) {
          n = true;
          tileList.add(
            Tile(
              x % 2 == 0
                  ? 'tile/generic-rpg-tile53.png'
                  : 'tile/generic-rpg-tile52.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }

        if (x >= 5 && x <= 30 && y >= 11 && y <= 13) {
          n = true;
          tileList.add(
            Tile(
              'tile/generic-rpg-Slice.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }

        if (x == 34 && y == 8) {
          n = true;
          tileList.add(
            Tile(
              'tile/generic-rpg-tile60.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }

        if (x == 34 && y >= 9 && y <= 13) {
          n = true;
          tileList.add(
            Tile(
              'tile/generic-rpg-tile49.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }

        if (x == 31 && y >= 11 && y <= 13) {
          n = true;
          tileList.add(
            Tile(
              'tile/generic-rpg-tile10.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }

        if (x == 31 && y == 10) {
          n = true;
          tileList.add(
            Tile(
              'tile/generic-rpg-tile09-2.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }

        if (x >= 31 && x <= 33 && y == 9) {
          n = true;
          tileList.add(
            Tile(
              'tile/generic-rpg-tile71.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }

        if (x >= 32 && x <= 33 && y >= 10 && y <= 13) {
          n = true;
          tileList.add(
            Tile(
              'tile/generic-rpg-tile71.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }

        if (!n) {
          tileList.add(
            Tile(
              'tile/generic-rpg-Slice.png',
              Position(x.toDouble(), y.toDouble()),
              size: tileSize,
            ),
          );
        }
      });
    });
    tileList.sort((t1, t2) =>
        (t1.positionInWorld.left - t2.positionInWorld.left).toInt());
    return MapWorld(tileList);
  }

  static Position getPosition(int x, int y) {
    return Position(x * tileSize, y * tileSize);
  }
}

import 'package:bonfire/bonfire.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:mountain_fight/main.dart';

class MountainMap {
  static final spriteSheet = SpriteSheet(
    imageName: 'tile/spritesheet.png',
    textureWidth: 16,
    textureHeight: 16,
    columns: 7,
    rows: 30,
  );

  static MapWorld map() {
    List<Tile> tileList = List();
    int limitBottom = 25;
    List.generate(50, (y) {
      List.generate(50, (x) {
        /// INICIO DA PRAIA
        //WATER
        if (x >= 0 && x <= 3 && y >= 0 && y <= limitBottom) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 4),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        //WATER
        if (x >= 4 && x <= 7 && y >= 10 && y <= limitBottom) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 4),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        //WATER
        if (x >= 8 && x <= 9 && y >= 20 && y <= limitBottom) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 4),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        //WATER
        if (x >= 4 && x <= 14 && y >= 0 && y < 2) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 4),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 4 && y == 2) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(10, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 5 && x <= 14 && y == 2) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(10, 1),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 15 && y == 2) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(23, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 15 && y < 2 && y >= 0) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 0),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 4 && y >= 3 && y <= 8) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 0),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 4 && y == 9) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(12, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 5 && x <= 7 && y == 9) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(12, 1),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 8 && y == 9) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(22, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 8 && y > 9 && y < 19) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 0),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 8 && y == 19) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(12, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 9 && y == 19) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(12, 1),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 10 && y == 19) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(22, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 10 && y > 19 && y < limitBottom) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 0),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 10 && y == limitBottom) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(12, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x > 10 && x <= 15 && y == limitBottom) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(12, 1),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x > 10 && x <= 50 && y == limitBottom) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(12, 1),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        //AREIA
        if (x > 4 && x <= 15 && y >= 3 && y <= 8) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x > 8 && x <= 15 && y >= 9 && y <= 18) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x > 10 && x <= 24 && y >= 21 && y <= 24) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 25 && y >= 21 && y <= 23) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(17, 2),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 25 && y == 24) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(14, 4),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x > 10 && x <= 15 && y >= 19 && y <= 24) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        /// FIM DA PRAIA

        if (x == 16 && y >= 0 && y < 20) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(17, 2),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 16 && y == 20) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(14, 4),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 17 && x <= 24 && y == 20) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(16, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 25 && y == 20) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(16, 2),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 17 && x <= 25 && y == 19) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(0, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 17 && x <= 19 && y >= 5 && y <= 18) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(0, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 17 && y <= 3 && y >= 0) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(5, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 17 && y == 4) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(6, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x >= 18 && x <= 19 && y == 4) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(9, 2),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 20 && y == 4) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(8, 5),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 20 && y >= 5 && y < 18) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(5, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 20 && y == 18) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(6, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 21 && y == 18) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(6, 4),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x >= 22 && x <= 23 && y == 18) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(9, 2),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 24 && x <= 25 && y == 18) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(6, 4),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 26 && y == 18) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(8, 5),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 26 && y >= 19 && y <= 22) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(5, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 26 && y == 23) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(6, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x >= 27 && x <= 50 && y == 23) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(6, 4),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x >= 26 && x <= 50 && y == 24) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(16, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }
      });
    });
    tileList
        .sort((t1, t2) => compareTo(t1.positionInWorld, t2.positionInWorld));
    return MapWorld(tileList);
  }

  static List<GameDecoration> decorations() {
    return [];
  }

  static int compareTo(Rect r1, Rect r2) {
    double c1 = double.parse('${r1.top.toInt()}${r1.left.toInt()}');
    double c2 = double.parse('${r2.top.toInt()}${r2.left.toInt()}');
    return c1.compareTo(c2);
  }

  static Position getPositionInWorld(int x, int y) {
    return Position(x * tileSize, y * tileSize);
  }

  static Position getPosition(int x, int y) {
    return Position(x.toDouble(), y.toDouble());
  }
}

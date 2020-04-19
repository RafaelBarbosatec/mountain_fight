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
        if (x >= 0 && x < 4 && y >= 0 && y <= limitBottom) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 5),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 4 && y >= 4 && y <= 8) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(11, 0),
            getPosition(x, y),
            size: tileSize,
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
          ));
        }

        if (x == 8 && y == 9) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(22, 1),
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
    return [
      GameDecoration.sprite(
        spriteSheet.getSprite(1, 6),
        initPosition: getPositionInWorld(5, 10),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(1, 6),
        initPosition: getPositionInWorld(15, 4),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(2, 6),
        initPosition: getPositionInWorld(8, 4),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(4, 6),
        initPosition: getPositionInWorld(15, 9),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(4, 6),
        initPosition: getPositionInWorld(15, 7),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(5, 6),
        initPosition: getPositionInWorld(10, 7),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(5, 6),
        initPosition: getPositionInWorld(4, 6),
        height: tileSize,
        width: tileSize,
      ),
    ];
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

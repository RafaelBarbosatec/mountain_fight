import 'dart:math';

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
    rows: 13,
  );

  static MapWorld map() {
    List<Tile> tileList = List();
    List.generate(20, (y) {
      List.generate(50, (x) {
        if (x == 3 && y == 3) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(4, 3),
            Position(
              x.toDouble(),
              y.toDouble(),
            ),
            size: tileSize,
          ));
        }

        if (x > 3 && x < 20 && y == 3) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(4, 4),
            Position(
              x.toDouble(),
              y.toDouble(),
            ),
            size: tileSize,
          ));
        }

        if (x == 20 && y == 3) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(4, 5),
            Position(
              x.toDouble(),
              y.toDouble(),
            ),
            size: tileSize,
          ));
        }

        if (x == 20 && y > 3 && y < 13) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(5, 5),
            Position(
              x.toDouble(),
              y.toDouble(),
            ),
            size: tileSize,
          ));
        }

        if (x == 20 && y == 13) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(6, 5),
            Position(
              x.toDouble(),
              y.toDouble(),
            ),
            size: tileSize,
          ));
        }

        if (x == 3 && y > 3 && y < 13) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(5, 3),
            Position(
              x.toDouble(),
              y.toDouble(),
            ),
            size: tileSize,
          ));
        }

        if (x == 3 && y == 13) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(6, 3),
            Position(
              x.toDouble(),
              y.toDouble(),
            ),
            size: tileSize,
          ));
        }

        if (x > 3 && x < 20 && y == 13) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(6, 4),
            Position(
              x.toDouble(),
              y.toDouble(),
            ),
            size: tileSize,
          ));
        }

        if (x > 3 && x < 20 && y > 3 && y < 13) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(
                0, Random().nextInt(100) % 2 == 0 ? 0 : Random().nextInt(3)),
            Position(
              x.toDouble(),
              y.toDouble(),
            ),
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
        initPosition: getPosition(5, 10),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(1, 6),
        initPosition: getPosition(15, 4),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(2, 6),
        initPosition: getPosition(8, 4),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(4, 6),
        initPosition: getPosition(15, 9),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(4, 6),
        initPosition: getPosition(15, 7),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(5, 6),
        initPosition: getPosition(10, 7),
        height: tileSize,
        width: tileSize,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(5, 6),
        initPosition: getPosition(4, 6),
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

  static Position getPosition(int x, int y) {
    return Position(x * tileSize, y * tileSize);
  }
}

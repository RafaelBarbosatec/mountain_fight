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

        // INICIO ILHA

        if (x == 25 && y == 8) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(25, 2),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x >= 26 && x <= 28 && y == 8) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(25, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x >= 32 && x <= 36 && y == 8) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(25, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 25 && y >= 9 && y <= 11) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(26, 2),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 25 && y == 12) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(28, 2),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x >= 26 && x <= 28 && y == 12) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(28, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x >= 32 && x <= 36 && y == 12) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(28, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 37 && y == 12) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(18, 4),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 37 && y >= 13 && y <= 16) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(26, 2),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 37 && y == 17) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(28, 2),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x >= 38 && x <= 40 && y == 17) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(28, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 41 && y == 17) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(28, 6),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 41 && y <= 16 && y >= 6) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(27, 6),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 41 && y == 5) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(25, 6),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x <= 40 && x >= 38 && y == 5) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(25, 4),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 37 && y == 5) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(25, 2),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 37 && y >= 6 && y <= 7) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(27, 2),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        if (x == 37 && y == 8) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(19, 4),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        //Water
        if (x >= 38 && x <= 40 && y >= 6 && y <= 16) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(26, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        //Water
        if (x == 37 && y == 9) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(27, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        //Water
        if (x == 37 && y == 10) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(26, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        //Water
        if (x == 37 && y == 11) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(27, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        //water
        if (x >= 32 && x <= 36 && y >= 9 && y <= 11) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(26, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        //water
        if (x >= 26 && x <= 28 && y == 9) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(26, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        //water
        if (x == 26 && y == 10) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(27, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        //water
        if (x >= 27 && x <= 28 && y == 10) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(26, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }
        //water
        if (x >= 26 && x <= 28 && y == 11) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(26, 3),
            getPosition(x, y),
            size: tileSize,
            collision: true,
          ));
        }

        //ponte
        if (x == 29 && y == 12) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(21, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }
        if (x == 30 && y == 12) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(21, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 31 && y == 12) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(21, 2),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 29 && y <= 11 && y >= 9) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(20, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 31 && y <= 11 && y >= 9) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(20, 2),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 30 && y <= 11 && y >= 9) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(20, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 29 && y == 8) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(19, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 30 && y == 8) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(19, 1),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x == 31 && y == 8) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(19, 2),
            getPosition(x, y),
            size: tileSize,
          ));
        }
        // fin da ponte

        // inicio grama
        if (x >= 18 && x <= 49 && y >= 0 && y <= 3) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(0, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 21 && x <= 49 && y == 4) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(0, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 21 && x <= 36 && y >= 5 && y <= 7) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(0, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 21 && x <= 24 && y >= 8 && y <= 17) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(0, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 25 && x <= 36 && y >= 13 && y <= 17) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(0, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 27 && x <= 49 && y >= 18 && y <= 22) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(0, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        if (x >= 42 && x <= 49 && y >= 5 && y <= 17) {
          tileList.add(Tile.fromSprite(
            spriteSheet.getSprite(0, 0),
            getPosition(x, y),
            size: tileSize,
          ));
        }

        // finaliza grama
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
        initPosition: getPositionInWorld(17, 9),
        height: tileSize,
        width: tileSize,
        collision: Collision(
          width: tileSize,
          height: tileSize,
        ),
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(24, 3),
        initPosition: getPositionInWorld(20, 14),
        height: tileSize,
        width: tileSize,
        frontFromPlayer: true,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(24, 4),
        initPosition: getPositionInWorld(21, 14),
        height: tileSize,
        width: tileSize,
        collision: Collision(
          width: tileSize,
          height: tileSize,
        ),
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(24, 5),
        initPosition: getPositionInWorld(22, 14),
        height: tileSize,
        width: tileSize,
        collision: Collision(
          width: tileSize,
          height: tileSize,
        ),
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(24, 6),
        initPosition: getPositionInWorld(23, 14),
        height: tileSize,
        width: tileSize,
        frontFromPlayer: true,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(23, 3),
        initPosition: getPositionInWorld(20, 13),
        height: tileSize,
        width: tileSize,
        frontFromPlayer: true,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(23, 4),
        initPosition: getPositionInWorld(21, 13),
        height: tileSize,
        width: tileSize,
        frontFromPlayer: true,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(23, 5),
        initPosition: getPositionInWorld(22, 13),
        height: tileSize,
        width: tileSize,
        frontFromPlayer: true,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(23, 6),
        initPosition: getPositionInWorld(23, 13),
        height: tileSize,
        width: tileSize,
        frontFromPlayer: true,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(20, 4),
        initPosition: getPositionInWorld(21, 12),
        height: tileSize,
        width: tileSize,
        frontFromPlayer: true,
      ),
      GameDecoration.sprite(
        spriteSheet.getSprite(20, 5),
        initPosition: getPositionInWorld(22, 12),
        height: tileSize,
        width: tileSize,
        frontFromPlayer: true,
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

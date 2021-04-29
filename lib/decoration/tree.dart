import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:mountain_fight/util/functions.dart';

class Tree extends GameDecoration with ObjectCollision {
  Tree(Vector2 position)
      : super.withSprite(
          Sprite.load('tree.png'),
          position: position,
          width: getSizeByTileSize(64),
          height: getSizeByTileSize(48),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Size(getSizeByTileSize(32), getSizeByTileSize(16)),
            align: Vector2(
              getSizeByTileSize(16),
              getSizeByTileSize(32),
            ),
          ),
        ],
      ),
    );
  }
}

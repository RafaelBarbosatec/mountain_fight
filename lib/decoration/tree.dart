import 'package:bonfire/bonfire.dart';
import 'package:mountain_fight/util/functions.dart';

class Tree extends GameDecoration with ObjectCollision {
  Tree(Vector2 position)
      : super.withSprite(
          sprite: Sprite.load('tree.png'),
          position: position,
          size: Vector2(
            getSizeByTileSize(64),
            getSizeByTileSize(48),
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(getSizeByTileSize(32), getSizeByTileSize(16)),
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

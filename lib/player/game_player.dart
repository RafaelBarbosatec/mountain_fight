import 'package:bonfire/bonfire.dart';
import 'package:flame/animation.dart';
import 'package:mountain_fight/main.dart';

class GamePlayer extends Player {
  final Position initPosition;

  GamePlayer(this.initPosition, SpriteSheet spriteSheet)
      : super(
          animIdleTop: spriteSheet.createAnimation(0, stepTime: 0.1),
          animIdleBottom: spriteSheet.createAnimation(1, stepTime: 0.1),
          animIdleLeft: spriteSheet.createAnimation(2, stepTime: 0.1),
          animIdleRight: spriteSheet.createAnimation(3, stepTime: 0.1),
          animRunTop: spriteSheet.createAnimation(4, stepTime: 0.1),
          animRunBottom: spriteSheet.createAnimation(5, stepTime: 0.1),
          animRunLeft: spriteSheet.createAnimation(6, stepTime: 0.1),
          animRunRight: spriteSheet.createAnimation(7, stepTime: 0.1),
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          initPosition: initPosition,
          life: 200,
          speed: tileSize / 12,
          collision:
              Collision(height: (tileSize * 0.5), width: (tileSize * 0.6)),
        );

  void showEmote(Animation emoteAnimation) {
    gameRef.add(
      AnimatedFollowerObject(
        animation: emoteAnimation,
        target: this,
        width: position.width / 2,
        height: position.width / 2,
        positionFromTarget: Position(25, -10),
      ),
    );
  }
}

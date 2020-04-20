import 'package:bonfire/bonfire.dart';
import 'package:flame/spritesheet.dart';
import 'package:mountain_fight/main.dart';

class GamePlayer extends Player {
  static final spriteSheetHeroes = SpriteSheet(
    imageName: 'heroes/heroesSpriteSheet.png',
    textureWidth: 32,
    textureHeight: 32,
    columns: 3,
    rows: 8,
  );
  final Position initPosition;

  GamePlayer(this.initPosition)
      : super(
            animIdleTop: spriteSheetHeroes.createAnimation(0, stepTime: 0.1),
            animIdleBottom: spriteSheetHeroes.createAnimation(1, stepTime: 0.1),
            animIdleLeft: spriteSheetHeroes.createAnimation(2, stepTime: 0.1),
            animIdleRight: spriteSheetHeroes.createAnimation(3, stepTime: 0.1),
            animRunTop: spriteSheetHeroes.createAnimation(4, stepTime: 0.1),
            animRunBottom: spriteSheetHeroes.createAnimation(5, stepTime: 0.1),
            animRunLeft: spriteSheetHeroes.createAnimation(6, stepTime: 0.1),
            animRunRight: spriteSheetHeroes.createAnimation(7, stepTime: 0.1),
            width: tileSize * 1.5,
            height: tileSize * 1.5,
            initPosition: initPosition,
            life: 200,
            speed: 2.5,
            collision: Collision(height: 16, width: 16));
}

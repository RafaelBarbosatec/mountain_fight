import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/local_player/local_player_controller.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';

class LocalPlayer extends SimplePlayer
    with ObjectCollision, UseStateController<LocalPlayerController> {
  final int id;
  final String nick;

  LocalPlayer(this.id, this.nick, Vector2 position, SpriteSheet spriteSheet)
      : super(
          animation: SpriteSheetHero.animationBySpriteSheet(spriteSheet),
          size: Vector2.all(tileSize * 1.5),
          position: position,
          life: 100,
          speed: tileSize * 3,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2((tileSize * 0.5), (tileSize * 0.5)),
            align: Vector2((tileSize * 0.9) / 2, tileSize),
          ),
        ],
      ),
    );
  }

  void showEmote(SpriteAnimation emoteAnimation) {
    gameRef.add(
      AnimatedFollowerObject(
        animation: Future.value(emoteAnimation),
        target: this,
        size: Vector2.all(width / 2),
        positionFromTarget: Vector2(
          25,
          -10,
        ),
      ),
    );
  }

  @override
  void joystickAction(JoystickActionEvent action) {
    if (hasController) {
      controller.joystickAction(action);
    }

    super.joystickAction(action);
  }

  void execAttack() {
    final anim = SpriteSheetHero.attackAxe;
    this.simpleAttackRange(
      id: id,
      animationRight: anim,
      animationLeft: anim,
      animationUp: anim,
      animationDown: anim,
      animationDestroy: SpriteSheetHero.smokeExplosion,
      size: Vector2.all(tileSize * 0.9),
      speed: speed * 3,
      damage: 15,
      enableDiagonal: false,
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(tileSize * 0.9, tileSize * 0.9),
          )
        ],
      ),
    );
  }

  @override
  void receiveDamage(AttackFromEnum attacker, double damage, dynamic from) {
    this.showDamage(
      damage,
      config: TextStyle(
        color: Colors.red,
        fontSize: 14,
      ),
    );
    super.receiveDamage(attacker, damage, from);
    if (hasController) {
      controller.receiveDamage(damage, from);
    }
  }

  @override
  void die() {
    gameRef.add(
      AnimatedObjectOnce(
        animation: SpriteSheetHero.smokeExplosion,
        position: position,
        size: size,
      ),
    );
    gameRef.add(
      GameDecoration.withSprite(
        sprite: Sprite.load('crypt.png'),
        position: Vector2(
          position.x,
          position.y,
        ),
        size: size,
      ),
    );
    removeFromParent();
    super.die();
  }

  @override
  void onMove(double speed, Direction direction, double angle) {
    if (hasController) {
      controller.onMove(speed, direction);
    }
    super.onMove(speed, direction, angle);
  }

  @override
  void idle() {
    if (hasController) {
      controller.idle();
    }
    super.idle();
  }
}

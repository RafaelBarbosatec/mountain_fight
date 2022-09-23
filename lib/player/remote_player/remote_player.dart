import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/remote_player/remote_player_controller.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';

class RemotePlayer extends SimpleEnemy
    with UseStateController<RemotePlayerController>, ObjectCollision {
  final int id;
  final String nick;
  late TextPaint _textConfig;
  Vector2 sizeTextNick = Vector2.zero();

  RemotePlayer(
      this.id, this.nick, Vector2 initPosition, SpriteSheet spriteSheet)
      : super(
          animation: SpriteSheetHero.animationBySpriteSheet(spriteSheet),
          position: initPosition,
          size: Vector2.all(tileSize * 1.5),
          life: 100,
          speed: tileSize * 3,
        ) {
    _textConfig = TextPaint(
      style: TextStyle(
        fontSize: tileSize / 3,
        color: Colors.white,
      ),
    );
    sizeTextNick = _textConfig.measureText(nick);
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

  @override
  void render(Canvas canvas) {
    _renderNickName(canvas);
    this.drawDefaultLifeBar(
      canvas,
      height: size.y * 0.1,
      borderWidth: 2,
      borderRadius: BorderRadius.circular(2),
    );
    super.render(canvas);
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

  void _renderNickName(Canvas canvas) {
    _textConfig.render(
      canvas,
      nick,
      Vector2(
        position.x + ((width - sizeTextNick.x) / 2),
        position.y - sizeTextNick.y - 12,
      ),
    );
  }

  void execAttack(Direction? direction) {
    var anim = SpriteSheetHero.attackAxe;
    this.simpleAttackRange(
      id: id,
      animationRight: anim,
      interval: 0,
      direction: direction,
      animationDestroy: SpriteSheetHero.smokeExplosion,
      size: Vector2.all(tileSize * 0.9),
      speed: speed * 3,
      enableDiagonal: false,
      damage: 15,
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
  bool checkCanReceiveDamage(AttackFromEnum attacker, double damage, from) {
    return false;
  }

  void execShowDamage(double damage) {
    this.showDamage(
      damage,
      config: TextStyle(color: Colors.red, fontSize: 14),
    );
  }
}

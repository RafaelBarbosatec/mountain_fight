import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/socket/server_player_control.dart';
import 'package:mountain_fight/socket/socket_message.dart';

class RemotePlayer extends SimpleEnemy
    with ServerRemotePlayerControl, ObjectCollision {
  final int id;
  final String nick;
  TextPaint _textConfig;
  Vector2 sizeTextNick = Vector2.zero();

  RemotePlayer(this.id, this.nick, Vector2 initPosition,
      SpriteSheet spriteSheet, SocketManager socketManager)
      : super(
          animation: SimpleDirectionAnimation(
            idleUp: Future.value(
              spriteSheet.createAnimation(row: 0, stepTime: 0.1),
            ),
            idleDown: Future.value(
              spriteSheet.createAnimation(row: 1, stepTime: 0.1),
            ),
            idleLeft: Future.value(
              spriteSheet.createAnimation(row: 2, stepTime: 0.1),
            ),
            idleRight: Future.value(
              spriteSheet.createAnimation(row: 3, stepTime: 0.1),
            ),
            runUp: Future.value(
              spriteSheet.createAnimation(row: 4, stepTime: 0.1),
            ),
            runDown: Future.value(
              spriteSheet.createAnimation(row: 5, stepTime: 0.1),
            ),
            runLeft: Future.value(
              spriteSheet.createAnimation(row: 6, stepTime: 0.1),
            ),
            runRight: Future.value(
              spriteSheet.createAnimation(row: 7, stepTime: 0.1),
            ),
          ),
          position: initPosition,
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          life: 100,
          speed: tileSize * 3,
        ) {
    // setupCollision(
    //   CollisionConfig(
    //     collisions: [
    //       CollisionArea.rectangle(
    //         size: Size((tileSize * 0.5), (tileSize * 0.5)),
    //         align: Vector2((tileSize * 0.9) / 2, tileSize),
    //       ),
    //     ],
    //   ),
    // );
    _textConfig = TextPaint(
      config: TextPaintConfig(
        fontSize: tileSize / 3,
        color: Colors.white,
      ),
    );
    sizeTextNick = _textConfig.measureText(nick);
    setupServerPlayerControl(socketManager, id);
  }

  @override
  void render(Canvas canvas) {
    _renderNickName(canvas);
    this.drawDefaultLifeBar(
      canvas,
      height: 4,
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
      ),
    );
    gameRef.addGameComponent(
      GameDecoration.withSprite(
        Sprite.load('crypt.png'),
        position: Vector2(
          position.left,
          position.top,
        ),
        height: 30,
        width: 30,
      ),
    );
    remove();
    super.die();
  }

  void _renderNickName(Canvas canvas) {
    _textConfig.render(
      canvas,
      nick,
      Vector2(
        position.left + ((width - sizeTextNick.x) / 2),
        position.top - sizeTextNick.y - 14,
      ),
    );
  }

  @override
  void serverAttack(JoystickMoveDirectional direction) {
    var anim = SpriteSheetHero.attackAxe;
    this.simpleAttackRange(
      id: id,
      animationRight: anim,
      animationLeft: anim,
      animationUp: anim,
      animationDown: anim,
      interval: 0,
      direction: direction.getDirection(),
      animationDestroy: SpriteSheetHero.smokeExplosion,
      width: tileSize * 0.9,
      height: tileSize * 0.9,
      speed: speed * 1.5,
      enableDiagonal: false,
      damage: 15,
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Size(tileSize * 0.9, tileSize * 0.9),
          )
        ],
      ),
    );
  }

  @override
  void receiveDamage(double damage, from) {}
}

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/server_player_control.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/util/extensions.dart';

class RemotePlayer extends SimpleEnemy
    with ServerRemotePlayerControl, ObjectCollision {
  final int id;
  final String nick;
  TextConfig _textConfig;

  RemotePlayer(this.id, this.nick, Vector2 initPosition,
      SpriteSheet spriteSheet, SocketManager socketManager)
      : super(
          animation: SimpleDirectionAnimation(
            idleUp: Future.value(
                spriteSheet.createAnimation(row: 0, stepTime: 0.1)),
            idleDown: Future.value(
                spriteSheet.createAnimation(row: 1, stepTime: 0.1)),
            idleLeft: Future.value(
                spriteSheet.createAnimation(row: 2, stepTime: 0.1)),
            idleRight: Future.value(
                spriteSheet.createAnimation(row: 3, stepTime: 0.1)),
            runUp: Future.value(
                spriteSheet.createAnimation(row: 4, stepTime: 0.1)),
            runDown: Future.value(
                spriteSheet.createAnimation(row: 5, stepTime: 0.1)),
            runLeft: Future.value(
                spriteSheet.createAnimation(row: 6, stepTime: 0.1)),
            runRight: Future.value(
                spriteSheet.createAnimation(row: 7, stepTime: 0.1)),
          ),
          position: initPosition,
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          life: 100,
          speed: tileSize * 3,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Size((tileSize * 0.5), (tileSize * 0.5)),
            align: Vector2((tileSize * 0.9) / 2, tileSize),
          ),
        ],
      ),
    );
    _textConfig = TextConfig(
      fontSize: tileSize / 4,
    );
    setupServerPlayerControl(socketManager, id);
  }

  @override
  void render(Canvas canvas) {
    if (this.isVisibleInCamera()) {
      _renderNickName(canvas);
      this.drawDefaultLifeBar(canvas, strokeWidth: 4, padding: 0);
    }
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
    _textConfig.withColor(Colors.white).render(
          canvas,
          nick,
          Vector2(
            position.left + ((width - (nick.length * (width / 13))) / 2),
            position.top - 20,
          ),
        );
  }

  @override
  void serverAttack(String direction) {
    var anim = SpriteSheetHero.attackAxe;
    this.simpleAttackRange(
      id: id,
      animationRight: anim,
      animationLeft: anim,
      animationUp: anim,
      animationDown: anim,
      interval: 0,
      direction: direction.getDirectionEnum(),
      animationDestroy: SpriteSheetHero.smokeExplosion,
      width: tileSize * 0.9,
      height: tileSize * 0.9,
      speed: speed * 1.5,
      damage: 15,
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(size: Size(tileSize * 0.9, tileSize * 0.9))
        ],
      ),
    );
  }

  @override
  void receiveDamage(double damage, from) {}
}

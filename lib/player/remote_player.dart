import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/server_player_control.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/util/extensions.dart';

class RemotePlayer extends SimpleEnemy with ServerPlayerControl {
  static const REDUCTION_SPEED_DIAGONAL = 0.7;
  final int id;
  final String nick;
  String currentMove = 'IDLE';
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
          // collision: Collision(
          //   height: (tileSize * 0.5),
          //   width: (tileSize * 0.6),
          //   align: Offset((tileSize * 0.9) / 2, tileSize),
          // ),
        ) {
    _textConfig = TextConfig(
      fontSize: tileSize / 4,
    );
    setupServerPlayerControl(socketManager, id);
  }

  @override
  void update(double dt) {
    _move(currentMove, dt);
    super.update(dt);
  }

  void _move(move, double dtUpdate) {
    switch (move) {
      case 'LEFT':
        this.moveLeft(speed * dtUpdate);
        break;
      case 'RIGHT':
        this.moveRight(speed * dtUpdate);
        break;
      case 'UP_RIGHT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        moveUpRight(
          speedDiagonal,
          speedDiagonal,
        );
        break;
      case 'DOWN_RIGHT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        moveDownRight(
          speedDiagonal,
          speedDiagonal,
        );

        break;
      case 'DOWN_LEFT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        moveDownLeft(
          speedDiagonal,
          speedDiagonal,
        );
        break;
      case 'UP_LEFT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        moveUpLeft(
          speedDiagonal,
          speedDiagonal,
        );
        break;
      case 'UP':
        this.moveUp(speed * dtUpdate);
        break;
      case 'DOWN':
        this.moveDown(speed * dtUpdate);
        break;
      case 'IDLE':
        this.idle();
        break;
    }
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

  void _execAttack(String direction) {
    var anim = SpriteAnimation.load(
      'axe_spin_atack.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.05,
        textureSize: Vector2(148, 148),
      ),
    );
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
        collisionOnlyVisibleScreen: false,
      ),
    );
  }

  @override
  void receiveDamage(double damage, dynamic from) {}

  @override
  void serverAttack(String direction) {
    _execAttack(direction);
  }

  @override
  void serverMove(String direction, Rect serverPosition) {
    currentMove = direction;

    /// Corrige posição se ele estiver muito diferente da do server
    Point p = Point(serverPosition.center.dx, serverPosition.center.dy);
    double dist = p.distanceTo(Point(
      position.center.dx,
      position.center.dy,
    ));

    if (dist > (tileSize * 0.5)) {
      position = serverPosition.toVector2Rect();
    }
  }

  @override
  void serverPlayerLeave() {
    if (!isDead) {
      die();
    }
  }

  @override
  void serverReceiveDamage(double damage) {
    if (!isDead) {
      this.showDamage(
        damage,
        config: TextConfig(color: Colors.red, fontSize: 14),
      );
      if (life > 0) {
        life -= damage;
        if (life <= 0) {
          die();
        }
      }
    }
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
}

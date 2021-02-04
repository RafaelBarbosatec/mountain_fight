import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/server_player_control.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/util/extensions.dart';

class RemotePlayer extends SimpleEnemy with ServerPlayerControl {
  static const REDUCTION_SPEED_DIAGONAL = 0.7;
  final int id;
  final String nick;
  String currentMove = 'IDLE';
  TextConfig _textConfig;

  RemotePlayer(this.id, this.nick, Position initPosition, SpriteSheet spriteSheet, SocketManager socketManager)
      : super(
          animation: SimpleDirectionAnimation(
            idleTop: spriteSheet.createAnimation(0, stepTime: 0.1),
            idleBottom: spriteSheet.createAnimation(1, stepTime: 0.1),
            idleLeft: spriteSheet.createAnimation(2, stepTime: 0.1),
            idleRight: spriteSheet.createAnimation(3, stepTime: 0.1),
            runTop: spriteSheet.createAnimation(4, stepTime: 0.1),
            runBottom: spriteSheet.createAnimation(5, stepTime: 0.1),
            runLeft: spriteSheet.createAnimation(6, stepTime: 0.1),
            runRight: spriteSheet.createAnimation(7, stepTime: 0.1),
          ),
          initPosition: initPosition,
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          life: 100,
          speed: tileSize * 3,
          collision: Collision(
            height: (tileSize * 0.5),
            width: (tileSize * 0.6),
            align: Offset((tileSize * 0.9) / 2, tileSize),
          ),
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
        this.customMoveLeft(speed * dtUpdate);
        break;
      case 'RIGHT':
        this.customMoveRight(speed * dtUpdate);
        break;
      case 'UP_RIGHT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        customMoveRight(
          speedDiagonal,
        );
        customMoveTop(speedDiagonal, addAnimation: false);
        break;
      case 'DOWN_RIGHT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        customMoveRight(
          speedDiagonal,
        );
        customMoveBottom(speedDiagonal, addAnimation: false);

        break;
      case 'DOWN_LEFT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        customMoveLeft(
          speedDiagonal,
        );
        customMoveBottom(speedDiagonal, addAnimation: false);
        break;
      case 'UP_LEFT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        customMoveLeft(
          speedDiagonal,
        );
        customMoveTop(speedDiagonal, addAnimation: false);
        break;
      case 'UP':
        this.customMoveTop(speed * dtUpdate);
        break;
      case 'DOWN':
        this.customMoveBottom(speed * dtUpdate);
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
        animation: FlameAnimation.Animation.sequenced(
          "smoke_explosin.png",
          6,
          textureWidth: 16,
          textureHeight: 16,
        ),
        position: position,
      ),
    );
    gameRef.addGameComponent(
      GameDecoration.sprite(
        Sprite('crypt.png'),
        initPosition: Position(
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
    var anim = FlameAnimation.Animation.sequenced(
      'axe_spin_atack.png',
      8,
      textureWidth: 148,
      textureHeight: 148,
      stepTime: 0.05,
    );
    this.simpleAttackRange(
      id: id,
      animationRight: anim,
      animationLeft: anim,
      animationTop: anim,
      animationBottom: anim,
      interval: 0,
      direction: direction.getDirectionEnum(),
      animationDestroy: FlameAnimation.Animation.sequenced(
        "smoke_explosin.png",
        6,
        textureWidth: 16,
        textureHeight: 16,
      ),
      width: tileSize * 0.9,
      height: tileSize * 0.9,
      speed: speed * 1.5,
      damage: 15,
      collision: Collision(
        width: tileSize * 0.9,
        height: tileSize * 0.9,
      ),
      collisionOnlyVisibleObjects: false,
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
      position = serverPosition;
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
          Position(
            position.left + ((width - (nick.length * (width / 13))) / 2),
            position.top - 20,
          ),
        );
  }
}

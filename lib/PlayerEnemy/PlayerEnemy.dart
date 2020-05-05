import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/socket/SocketManager.dart';

class PlayerEnemy extends SimpleEnemy {
  static const REDUCTION_SPEED_DIAGONAL = 0.7;
  final int id;
  final String nick;

  double conpensasionX = 0;
  double speedConpensasionX = 0;
  double conpensasionY = 0;
  double speedConpensasionY = 0;

  String currentMove = 'IDLE';

  TextConfig _textConfig;

  PlayerEnemy(
      this.id, this.nick, Position initPosition, SpriteSheet spriteSheet)
      : super(
          initPosition: initPosition,
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          animationIdleTop: spriteSheet.createAnimation(0, stepTime: 0.1),
          animationIdleBottom: spriteSheet.createAnimation(1, stepTime: 0.1),
          animationIdleLeft: spriteSheet.createAnimation(2, stepTime: 0.1),
          animationIdleRight: spriteSheet.createAnimation(3, stepTime: 0.1),
          animationRunTop: spriteSheet.createAnimation(4, stepTime: 0.1),
          animationRunBottom: spriteSheet.createAnimation(5, stepTime: 0.1),
          animationRunLeft: spriteSheet.createAnimation(6, stepTime: 0.1),
          animationRunRight: spriteSheet.createAnimation(7, stepTime: 0.1),
          life: 200,
          speed: tileSize / 0.22,
          collision: Collision(
            height: (tileSize * 0.5),
            width: (tileSize * 0.6),
          ),
        ) {
    _textConfig = TextConfig(
      fontSize: height / 3.5,
    );
    SocketManager().listen('message', (data) {
      String action = data['action'];
      if (data['data']['player_id'] == id) {
        if (action == 'MOVE') {
          double positionX =
              double.parse(data['data']['position']['x'].toString()) * tileSize;
          double positionY =
              double.parse(data['data']['position']['y'].toString()) * tileSize;
          Rect newP = Rect.fromLTWH(
            positionX,
            positionY,
            positionInWorld.width,
            positionInWorld.height,
          );
          Point p = Point(newP.center.dx, newP.center.dy);
          double dist = p.distanceTo(Point(
            positionInWorld.center.dx,
            positionInWorld.center.dy,
          ));

          if (dist > (tileSize * 0.9)) {
            positionInWorld = newP;
          }

          currentMove = data['data']['direction'];
        }
      }
      if (action == 'PLAYER_LEAVED' && data['data']['id'] == id) {
        if (!isDead) {
          die();
        }
      }
    });
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
    if (this.isVisibleInMap()) {
      _textConfig.withColor(Colors.white).render(
            canvas,
            nick,
            Position(position.left + 2, position.top - 20),
          );
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
        position: positionInWorld,
      ),
    );
    remove();
    super.die();
  }
}

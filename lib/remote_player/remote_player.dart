import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/util/buffer_delay.dart';
import 'package:mountain_fight/util/extensions.dart';

class RemotePlayer extends SimpleEnemy {
  static const REDUCTION_SPEED_DIAGONAL = 0.7;
  final int id;
  final String nick;

  String currentMove = 'IDLE';

  TextConfig _textConfig;

  BufferDelay _buffer;

  RemotePlayer(
      this.id, this.nick, Position initPosition, SpriteSheet spriteSheet)
      : super(
          initPosition: initPosition,
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          animIdleTop: spriteSheet.createAnimation(0, stepTime: 0.1),
          animIdleBottom: spriteSheet.createAnimation(1, stepTime: 0.1),
          animIdleLeft: spriteSheet.createAnimation(2, stepTime: 0.1),
          animIdleRight: spriteSheet.createAnimation(3, stepTime: 0.1),
          animRunTop: spriteSheet.createAnimation(4, stepTime: 0.1),
          animRunBottom: spriteSheet.createAnimation(5, stepTime: 0.1),
          animRunLeft: spriteSheet.createAnimation(6, stepTime: 0.1),
          animRunRight: spriteSheet.createAnimation(7, stepTime: 0.1),
          life: 100,
          speed: tileSize * 3,
          collision: Collision(
            height: (tileSize * 0.5),
            width: (tileSize * 0.6),
            align: Offset((tileSize * 0.9) / 2, tileSize),
          ),
        ) {
    _buffer = BufferDelay(100);
    _buffer.listen(_listenBuffer);
    _textConfig = TextConfig(
      fontSize: height / 3.5,
    );
    SocketManager().listen('message', (data) {
//      print('REMOTE listem(message) - $data');
      String action = data['action'];
      if (action != 'PLAYER_LEAVED' && data['time'] != null) {
        _buffer.add(
          data,
          DateTime.parse(
            data['time'].toString(),
          ),
        );
      }

      if (action == 'RECEIVED_DAMAGE') {
        if (!isDead) {
          double damage = double.parse(data['data']['damage'].toString());
          this.showDamage(damage,
              config: TextConfig(color: Colors.red, fontSize: 14));
          if (life > 0) {
            life -= damage;
            if (life <= 0) {
              die();
            }
          }
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
    if (this.isVisibleInCamera()) {
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

  void _listenBuffer(data) {
    String action = data['action'];
    if (data['data']['player_id'] == id) {
      if (action == 'MOVE') {
        _exeMovement(data['data']);
      }
      if (action == 'ATTACK') {
        _execAttack(data['data']['direction']);
      }
    }
  }

  void _exeMovement(data) {
    _correctPosition(data);
    currentMove = data['direction'];
  }

  void _correctPosition(data) {
    double positionX =
        double.parse(data['position']['x'].toString()) * tileSize;
    double positionY =
        double.parse(data['position']['y'].toString()) * tileSize;
    Rect newP = Rect.fromLTWH(
      positionX,
      positionY,
      position.width,
      position.height,
    );
    Point p = Point(newP.center.dx, newP.center.dy);
    double dist = p.distanceTo(Point(
      position.center.dx,
      position.center.dy,
    ));

    if (dist > (tileSize * 0.5)) {
      position = newP;
    }
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
  void receiveDamage(double damage, int from) {}
}

import 'dart:async';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/util/extensions.dart';

class GamePlayer extends SimplePlayer {
  final Position initPosition;
  final int id;
  final String nick;
  double stamina = 100;
  JoystickMoveDirectional currentDirection;
  TextConfig _textConfig;
  Timer _timerStamina;
  String directionEvent = 'IDLE';

  GamePlayer(this.id, this.nick, this.initPosition, SpriteSheet spriteSheet)
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
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          initPosition: initPosition,
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
  }

  void _verifyStamina() {
    if (_timerStamina == null) {
      _timerStamina = Timer(Duration(milliseconds: 150), () {
        _timerStamina = null;
      });
    } else {
      return;
    }

    stamina += 2;
    if (stamina > 100) {
      stamina = 100;
    }
  }

  void decrementStamina(int i) {
    stamina -= i;
    if (stamina < 0) {
      stamina = 0;
    }
  }

  @override
  void update(double dt) {
    if (isDead) return;
    _verifyStamina();
    super.update(dt);
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    if (event.directional != currentDirection && position != null) {
      currentDirection = event.directional;
      switch (currentDirection) {
        case JoystickMoveDirectional.MOVE_UP:
          directionEvent = 'UP';
          break;
        case JoystickMoveDirectional.MOVE_UP_LEFT:
          directionEvent = 'UP_LEFT';
          break;
        case JoystickMoveDirectional.MOVE_UP_RIGHT:
          directionEvent = 'UP_RIGHT';
          break;
        case JoystickMoveDirectional.MOVE_RIGHT:
          directionEvent = 'RIGHT';
          break;
        case JoystickMoveDirectional.MOVE_DOWN:
          directionEvent = 'DOWN';
          break;
        case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
          directionEvent = 'DOWN_RIGHT';
          break;
        case JoystickMoveDirectional.MOVE_DOWN_LEFT:
          directionEvent = 'DOWN_LEFT';
          break;
        case JoystickMoveDirectional.MOVE_LEFT:
          directionEvent = 'LEFT';
          break;
        case JoystickMoveDirectional.IDLE:
          directionEvent = 'IDLE';
          break;
      }
      SocketManager().send(
        'message',
        {
          'action': 'MOVE',
          'time': DateTime.now().toIso8601String(),
          'data': {
            'player_id': id,
            'direction': directionEvent,
            'position': {'x': (position.left / tileSize), 'y': (position.top / tileSize)},
          }
        },
      );
    }

    super.joystickChangeDirectional(event);
  }

  void showEmote(FlameAnimation.Animation emoteAnimation) {
    gameRef.add(
      AnimatedFollowerObject(
        animation: emoteAnimation,
        target: this,
        positionFromTarget: Rect.fromLTWH(
          25,
          -10,
          position.width / 2,
          position.width / 2,
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    _textConfig.withColor(Colors.white).render(
          canvas,
          nick,
          Position(position.left + ((width - (nick.length * (width / 13))) / 2), position.top - (tileSize / 3)),
        );
    super.render(canvas);
  }

  @override
  void joystickAction(JoystickActionEvent action) {
    if (gameRef.joystickController.keyboardEnable && action.id == LogicalKeyboardKey.space.keyId) {
      _execAttack();
    }
    if (action.id == 0 && action.event == ActionEvent.DOWN) {
      _execAttack();
    }
    super.joystickAction(action);
  }

  void _execAttack() {
    if (stamina < 25 || isDead) {
      return;
    }
    decrementStamina(25);
    SocketManager().send('message', {
      'action': 'ATTACK',
      'time': DateTime.now().toIso8601String(),
      'data': {
        'player_id': id,
        'direction': this.lastDirection.getName(),
        'position': {'x': (position.left / tileSize), 'y': (position.top / tileSize)},
      }
    });
    var anim = FlameAnimation.Animation.sequenced('axe_spin_atack.png', 8,
        textureWidth: 148, textureHeight: 148, stepTime: 0.05);
    this.simpleAttackRange(
      id: id,
      animationRight: anim,
      animationLeft: anim,
      animationTop: anim,
      animationBottom: anim,
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
    );
  }

  @override
  void receiveDamage(double damage, dynamic from) {
    SocketManager().send('message', {
      'action': 'RECEIVED_DAMAGE',
      'time': DateTime.now().toIso8601String(),
      'data': {
        'player_id': id,
        'damage': damage,
        'player_id_attack': from,
      }
    });
    this.showDamage(
      damage,
      config: TextConfig(
        color: Colors.red,
        fontSize: 14,
      ),
    );
    super.receiveDamage(damage, from);
  }

  @override
  void die() {
    life = 0;
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
}

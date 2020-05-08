import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/util/extensions.dart';

class GamePlayer extends SimplePlayer {
  final Position initPosition;
  final int id;
  final String nick;
  JoystickMoveDirectional atualDiretional;
  TextConfig _textConfig;

  GamePlayer(this.id, this.nick, this.initPosition, SpriteSheet spriteSheet)
      : super(
          animIdleTop: spriteSheet.createAnimation(0, stepTime: 0.1),
          animIdleBottom: spriteSheet.createAnimation(1, stepTime: 0.1),
          animIdleLeft: spriteSheet.createAnimation(2, stepTime: 0.1),
          animIdleRight: spriteSheet.createAnimation(3, stepTime: 0.1),
          animRunTop: spriteSheet.createAnimation(4, stepTime: 0.1),
          animRunBottom: spriteSheet.createAnimation(5, stepTime: 0.1),
          animRunLeft: spriteSheet.createAnimation(6, stepTime: 0.1),
          animRunRight: spriteSheet.createAnimation(7, stepTime: 0.1),
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          initPosition: initPosition,
          life: 200,
          speed: tileSize / 0.22,
          collision: Collision(
            height: (tileSize * 0.5),
            width: (tileSize * 0.6),
          ),
          sizeCentralMovementWindow: Size(tileSize * 2, tileSize * 2),
        ) {
    _textConfig = TextConfig(
      fontSize: height / 3.5,
    );
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    if (event.directional != atualDiretional) {
      atualDiretional = event.directional;
      String diretionalEVent = '';
      switch (atualDiretional) {
        case JoystickMoveDirectional.MOVE_UP:
          diretionalEVent = 'UP';
          break;
        case JoystickMoveDirectional.MOVE_UP_LEFT:
          diretionalEVent = 'UP_LEFT';
          break;
        case JoystickMoveDirectional.MOVE_UP_RIGHT:
          diretionalEVent = 'UP_RIGHT';
          break;
        case JoystickMoveDirectional.MOVE_RIGHT:
          diretionalEVent = 'RIGHT';
          break;
        case JoystickMoveDirectional.MOVE_DOWN:
          diretionalEVent = 'DOWN';
          break;
        case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
          diretionalEVent = 'DOWN_RIGHT';
          break;
        case JoystickMoveDirectional.MOVE_DOWN_LEFT:
          diretionalEVent = 'DOWN_LEFT';
          break;
        case JoystickMoveDirectional.MOVE_LEFT:
          diretionalEVent = 'LEFT';
          break;
        case JoystickMoveDirectional.IDLE:
          diretionalEVent = 'IDLE';
          break;
      }
      SocketManager().send('message', {
        'action': 'MOVE',
        'time': DateTime.now().toIso8601String(),
        'data': {
          'player_id': id,
          'direction': diretionalEVent,
          'position': {
            'x': (positionInWorld.left / tileSize),
            'y': (positionInWorld.top / tileSize)
          },
        }
      });
    }

    super.joystickChangeDirectional(event);
  }

  void showEmote(FlameAnimation.Animation emoteAnimation) {
    gameRef.add(
      AnimatedFollowerObject(
        animation: emoteAnimation,
        target: this,
        width: position.width / 2,
        height: position.width / 2,
        positionFromTarget: Position(25, -10),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    _textConfig.withColor(Colors.white).render(
          canvas,
          nick,
          Position(position.left + 2, position.top - 20),
        );
    super.render(canvas);
  }

  @override
  void joystickAction(int action) {
    if (action == 0) {
      _execAttack();
    }
    super.joystickAction(action);
  }

  void _execAttack() {
    SocketManager().send('message', {
      'action': 'ATTACK',
      'time': DateTime.now().toIso8601String(),
      'data': {
        'player_id': id,
        'direction': this.lastDirection.getName(),
        'position': {
          'x': (positionInWorld.left / tileSize),
          'y': (positionInWorld.top / tileSize)
        },
      }
    });
    var anim = FlameAnimation.Animation.sequenced('axe_spin_atack.png', 8,
        textureWidth: 148, textureHeight: 148, stepTime: 0.05);
    this.simpleAttackRange(
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
      width: width / 1.5,
      height: width / 1.5,
      speed: speed * 1.5,
      damage: 30,
    );
  }

  @override
  void receiveDamage(double damage) {
    SocketManager().send('message', {
      'action': 'RECEIVED_DAMAGE',
      'time': DateTime.now().toIso8601String(),
      'data': {
        'player_id': id,
        'damage': damage,
      }
    });
    super.receiveDamage(damage);
  }
}

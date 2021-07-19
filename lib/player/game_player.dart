import 'dart:async' as async;
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/util/extensions.dart';

class GamePlayer extends SimplePlayer with ObjectCollision {
  final Vector2 initPosition;
  final int id;
  final String nick;
  double stamina = 100;
  JoystickMoveDirectional currentDirection;
  TextPaint _textConfig;
  async.Timer _timerStamina;
  String directionEvent = 'IDLE';

  GamePlayer(this.id, this.nick, this.initPosition, SpriteSheet spriteSheet)
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
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          position: initPosition,
          life: 100,
          speed: tileSize * 3,
        ) {
    setupCollision(CollisionConfig(collisions: [
      CollisionArea.rectangle(
        size: Size((tileSize * 0.5), (tileSize * 0.5)),
        align: Vector2((tileSize * 0.9) / 2, tileSize),
      ),
    ]));
    _textConfig = TextPaint(
      config: TextPaintConfig(
        fontSize: tileSize / 4,
        color: Colors.white,
      ),
    );
  }

  void _verifyStamina() {
    if (_timerStamina == null) {
      _timerStamina = async.Timer(Duration(milliseconds: 150), () {
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
            'position': {
              'x': (position.left / tileSize),
              'y': (position.top / tileSize)
            },
          }
        },
      );
    }

    super.joystickChangeDirectional(event);
  }

  void showEmote(SpriteAnimation emoteAnimation) {
    gameRef.add(
      AnimatedFollowerObject(
        animation: Future.value(emoteAnimation),
        target: this,
        positionFromTarget: Rect.fromLTWH(
          25,
          -10,
          position.width / 2,
          position.width / 2,
        ).toVector2Rect(),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    _textConfig.render(
      canvas,
      nick,
      Vector2(
        position.left + ((width - (nick.length * (width / 13))) / 2),
        position.top - (tileSize / 3),
      ),
    );
    super.render(canvas);
  }

  @override
  void joystickAction(JoystickActionEvent action) {
    if (action.id == LogicalKeyboardKey.space.keyId &&
        action.event == ActionEvent.DOWN) {
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
        'position': {
          'x': (position.left / tileSize),
          'y': (position.top / tileSize)
        },
      }
    });
    var anim = SpriteSheetHero.attackAxe;
    this.simpleAttackRange(
      id: id,
      animationRight: anim,
      animationLeft: anim,
      animationUp: anim,
      animationDown: anim,
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
      config: TextPaintConfig(
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
}

import 'dart:async' as async;
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/person_select.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/socket/socket_message.dart';

class GamePlayer extends SimplePlayer with ObjectCollision {
  final Vector2 initPosition;
  final int id;
  final String nick;
  double stamina = 100;
  JoystickMoveDirectional currentDirection;
  TextPaint _textConfig;
  async.Timer _timerStamina;
  Vector2 sizeTextNick = Vector2.zero();

  GamePlayer(this.id, this.nick, this.initPosition, SpriteSheet spriteSheet)
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
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          position: initPosition,
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
    _textConfig = TextPaint(
      config: TextPaintConfig(
        fontSize: tileSize / 3,
        color: Colors.white,
      ),
    );
    sizeTextNick = _textConfig.measureText(nick);
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
      SocketMessage socketEvent = SocketMessage(
        time: DateTime.now(),
        action: GameActionEnum.MOVE,
        data: SocketMessageData(
          playerId: id,
          direction: currentDirection,
          position: Offset(
            (position.left / tileSize),
            (position.top / tileSize),
          ),
        ),
      );
      SocketManager().send('message', socketEvent.toJson());
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
        position.left + ((width - sizeTextNick.x) / 2),
        position.top - sizeTextNick.y,
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
    SocketMessage socketEvent = SocketMessage(
      time: DateTime.now(),
      action: GameActionEnum.ATTACK,
      data: SocketMessageData(
        playerId: id,
        direction: lastDirection.getJoystickMoveDirectional(),
        position: Offset(
          (position.left / tileSize),
          (position.top / tileSize),
        ),
      ),
    );
    SocketManager().send('message', socketEvent.toJson());
    final anim = SpriteSheetHero.attackAxe;
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
      enableDiagonal: false,
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(size: Size(tileSize * 0.9, tileSize * 0.9))
        ],
      ),
    );
  }

  @override
  void receiveDamage(double damage, dynamic from) {
    SocketMessage socketEvent = SocketMessage(
      time: DateTime.now(),
      action: GameActionEnum.RECEIVED_DAMAGE,
      data: SocketMessageData(
        playerId: id,
        playerIdAttack: from,
        damage: damage,
        position: Offset(
          (position.left / tileSize),
          (position.top / tileSize),
        ),
      ),
    );
    SocketManager().send('message', socketEvent.toJson());
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
    async.Future.delayed(Duration(seconds: 1), _showDialogTryAgain);
    super.die();
  }

  async.FutureOr _showDialogTryAgain() {
    showDialog(
      context: gameRef.context,
      builder: (context) {
        return Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Game Over',
                  style: Theme.of(gameRef.context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(gameRef.context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonSelect(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text('Try again'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

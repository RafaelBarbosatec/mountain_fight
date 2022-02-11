import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/socket/socket_message.dart';

class GamePlayer extends SimplePlayer with ObjectCollision {
  final Vector2 initPosition;
  final int id;
  final String nick;
  double stamina = 100;
  Direction? cDirection;

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
          size: Vector2.all(tileSize * 1.5),
          position: initPosition,
          life: 100,
          speed: tileSize * 3,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2((tileSize * 0.5), (tileSize * 0.5)),
            align: Vector2((tileSize * 0.9) / 2, tileSize),
          ),
        ],
      ),
    );
  }

  void _verifyStamina(double dt) {
    if (checkInterval('STAMINA', 150, dt)) {
      stamina += 2;
      if (stamina > 100) {
        stamina = 100;
      }
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
    _verifyStamina(dt);
    super.update(dt);
  }

  void showEmote(SpriteAnimation emoteAnimation) {
    gameRef.add(
      AnimatedFollowerObject(
        animation: Future.value(emoteAnimation),
        target: this,
        size: Vector2.all(width / 2),
        positionFromTarget: Vector2(
          25,
          -10,
        ),
      ),
    );
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
        direction: lastDirection,
        position: Offset(
          (position.x / tileSize),
          (position.y / tileSize),
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
      size: Vector2.all(tileSize * 0.9),
      speed: speed * 3,
      damage: 15,
      enableDiagonal: false,
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(tileSize * 0.9, tileSize * 0.9),
          )
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
          (position.x / tileSize),
          (position.y / tileSize),
        ),
      ),
    );
    SocketManager().send('message', socketEvent.toJson());
    this.showDamage(
      damage,
      config: TextStyle(
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
        size: size,
      ),
    );
    gameRef.add(
      GameDecoration.withSprite(
        sprite: Sprite.load('crypt.png'),
        position: Vector2(
          position.x,
          position.y,
        ),
        size: size,
      ),
    );
    removeFromParent();
    super.die();
  }

  @override
  void onMove(double speed, Direction direction, double angle) {
    if (speed > 0) {
      _sendMove(direction);
    } else {
      _sendMove(null);
    }
    super.onMove(speed, direction, angle);
  }

  void _sendMove(Direction? direction) {
    if (direction != cDirection) {
      cDirection = direction;
      SocketMessage socketEvent = SocketMessage(
        time: DateTime.now(),
        action: GameActionEnum.MOVE,
        data: SocketMessageData(
          playerId: id,
          direction: cDirection,
          position: Offset(
            (position.x / tileSize),
            (position.y / tileSize),
          ),
        ),
      );
      SocketManager().send('message', socketEvent.toJson());
    }
  }

  @override
  void idle() {
    print('aqui');
    _sendMove(null);
    super.idle();
  }
}

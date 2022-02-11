import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/socket/socket_message.dart';
import 'package:mountain_fight/util/buffer_delay.dart';

mixin ServerRemotePlayerControl on SimpleEnemy {
  static const EVENT_SOCKET_NAME = 'message';
  static const ACTION_MOVE = 'MOVE';
  static const ACTION_ATTACK = 'ATTACK';
  static const ACTION_RECEIVED_DAMAGE = 'RECEIVED_DAMAGE';
  static const ACTION_PLAYER_LEAVED = 'PLAYER_LEAVED';
  static const REDUCTION_SPEED_DIAGONAL = 0.7;
  int playerId = 0;
  BufferDelay _bufferMoveAndAttack = BufferDelay(200);

  Direction? currentMove;

  void setupServerPlayerControl(
    SocketManager s,
    int id,
  ) {
    playerId = id;
    _bufferMoveAndAttack.listen(_listenBuffer);
    _setupSocket(s);
  }

  void _setupSocket(SocketManager s) {
    s.listen(EVENT_SOCKET_NAME, (data) {
      SocketMessage msg = SocketMessage.fromJson(data);
      bool isMine = msg.data.playerId == playerId;
      if (!isMine) return;

      if (msg.action == GameActionEnum.RECEIVED_DAMAGE) {
        serverReceiveDamage(msg.data.damage);
      } else if (msg.action == GameActionEnum.PLAYER_LEAVED) {
        serverPlayerLeave();
      } else {
        _bufferMoveAndAttack.add(
          msg,
          msg.time,
        );
      }
    });
  }

  void _listenBuffer(data) {
    SocketMessage event = data;
    if (event.action == GameActionEnum.MOVE) {
      double x = event.data.position.dx * tileSize;
      double y = event.data.position.dy * tileSize;
      Rect serverPosition = Rect.fromLTWH(
        x,
        y,
        width,
        height,
      );
      serverMove(event.data.direction, serverPosition);
    }
    if (event.action == GameActionEnum.ATTACK) {
      serverAttack(event.data.direction);
    }
  }

  @override
  void update(double dt) {
    _move(currentMove);
    super.update(dt);
  }

  void _move(Direction? direction) {
    switch (direction) {
      case Direction.left:
        this.moveLeft(speed);
        break;
      case Direction.right:
        this.moveRight(speed);
        break;
      case Direction.upRight:
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL);
        moveUpRight(
          speedDiagonal,
          speedDiagonal,
        );
        break;
      case Direction.downRight:
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL);
        moveDownRight(
          speedDiagonal,
          speedDiagonal,
        );

        break;
      case Direction.downLeft:
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL);
        moveDownLeft(
          speedDiagonal,
          speedDiagonal,
        );
        break;
      case Direction.upLeft:
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL);
        moveUpLeft(
          speedDiagonal,
          speedDiagonal,
        );
        break;
      case Direction.up:
        this.moveUp(speed);
        break;
      case Direction.down:
        this.moveDown(speed);
        break;
      default:
        this.idle();
    }
  }

  void serverMove(Direction? direction, Rect serverPosition) {
    currentMove = direction;

    /// Corrige posição se ele estiver muito diferente da do server
    Vector2 p = Vector2(serverPosition.left, serverPosition.top);
    double dist = p.distanceTo(position);

    if (dist > (tileSize * 0.5)) {
      position = serverPosition.positionVector2;
    }
  }

  void serverReceiveDamage(double damage) {
    if (!isDead) {
      this.showDamage(
        damage,
        config: TextStyle(color: Colors.red, fontSize: 14),
      );
      if (life > 0) {
        life -= damage;
        if (life <= 0) {
          die();
        }
      }
    }
  }

  void serverAttack(Direction? direction);

  void serverPlayerLeave() {
    if (!isDead) {
      die();
    }
  }
}

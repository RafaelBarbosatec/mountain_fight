import 'dart:math';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/util/buffer_delay.dart';

mixin ServerPlayerControl on SimpleEnemy {
  static const EVENT_SOCKET_NAME = 'message';
  static const ACTION_MOVE = 'MOVE';
  static const ACTION_ATTACK = 'ATTACK';
  static const ACTION_RECEIVED_DAMAGE = 'RECEIVED_DAMAGE';
  static const ACTION_PLAYER_LEAVED = 'PLAYER_LEAVED';
  static const REDUCTION_SPEED_DIAGONAL = 0.7;
  int _playerId;
  BufferDelay _bufferMoveAndAttack;

  String currentMove = 'IDLE';

  void setupServerPlayerControl(
    SocketManager s,
    int id,
  ) {
    _playerId = id;
    _bufferMoveAndAttack = BufferDelay(200);
    _bufferMoveAndAttack.listen(_listenBuffer);
    _setupSocket(s);
  }

  void _setupSocket(SocketManager s) {
    s.listen(EVENT_SOCKET_NAME, (data) {
      bool isMine = data['data']['player_id'] == _playerId;
      if (!isMine) return;

      String action = data['action'];
      String time = data['time'].toString();

      if (action == ACTION_RECEIVED_DAMAGE) {
        double damage = double.parse(data['data']['damage'].toString());
        serverReceiveDamage(damage);
      } else if (action == ACTION_PLAYER_LEAVED) {
        serverPlayerLeave();
      } else {
        _bufferMoveAndAttack.add(
          data,
          DateTime.parse(time),
        );
      }
    });
  }

  void _listenBuffer(data) {
    String action = data['action'];
    String direction = data['data']['direction'];
    if (action == ACTION_MOVE) {
      double x =
          double.parse(data['data']['position']['x'].toString()) * tileSize;
      double y =
          double.parse(data['data']['position']['y'].toString()) * tileSize;
      Rect serverPosition = Rect.fromLTWH(
        x,
        y,
        position.width,
        position.height,
      );
      serverMove(direction, serverPosition);
    }
    if (action == ACTION_ATTACK) {
      serverAttack(direction);
    }
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

  void serverAttack(String direction);

  void serverPlayerLeave() {
    if (!isDead) {
      die();
    }
  }
}

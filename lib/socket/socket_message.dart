import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

///
/// Created by
///
/// ─▄▀─▄▀
/// ──▀──▀
/// █▀▀▀▀▀█▄
/// █░░░░░█─█
/// ▀▄▄▄▄▄▀▀
///
/// Rafaelbarbosatec
/// on 08/09/21
enum GameActionEnum {
  MOVE,
  ATTACK,
  RECEIVED_DAMAGE,
  PLAYER_LEAVED,
}

extension GameActionEnumExt on GameActionEnum {
  String toText() {
    switch (this) {
      case GameActionEnum.MOVE:
        return 'MOVE';
      case GameActionEnum.ATTACK:
        return 'ATTACK';
      case GameActionEnum.RECEIVED_DAMAGE:
        return 'RECEIVED_DAMAGE';
      case GameActionEnum.PLAYER_LEAVED:
        return 'PLAYER_LEAVED';
    }
  }
}

extension DirectionExt on Direction {
  JoystickMoveDirectional getJoystickMoveDirectional() {
    switch (this) {
      case Direction.left:
        return JoystickMoveDirectional.MOVE_LEFT;
      case Direction.right:
        return JoystickMoveDirectional.MOVE_RIGHT;
      case Direction.up:
        return JoystickMoveDirectional.MOVE_UP;
      case Direction.down:
        return JoystickMoveDirectional.MOVE_DOWN;
      case Direction.upLeft:
        return JoystickMoveDirectional.MOVE_LEFT;
      case Direction.upRight:
        return JoystickMoveDirectional.MOVE_RIGHT;
      case Direction.downLeft:
        return JoystickMoveDirectional.MOVE_LEFT;
      case Direction.downRight:
        return JoystickMoveDirectional.MOVE_RIGHT;
    }
  }
}

extension JoystickMoveDirectionalExt on JoystickMoveDirectional {
  String toText() {
    switch (this) {
      case JoystickMoveDirectional.MOVE_LEFT:
        return 'LEFT';
      case JoystickMoveDirectional.MOVE_RIGHT:
        return 'RIGHT';
      case JoystickMoveDirectional.MOVE_UP:
        return 'UP';
      case JoystickMoveDirectional.MOVE_DOWN:
        return 'DOWN';
      case JoystickMoveDirectional.MOVE_UP_LEFT:
        return 'UP_LEFT';
      case JoystickMoveDirectional.MOVE_UP_RIGHT:
        return 'UP_RIGHT';
      case JoystickMoveDirectional.MOVE_DOWN_LEFT:
        return 'DOWN_LEFT';
      case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
        return 'DOWN_RIGHT';
      case JoystickMoveDirectional.IDLE:
        return 'IDLE';
    }
  }

  Direction getDirection() {
    switch (this) {
      case JoystickMoveDirectional.MOVE_UP:
        return Direction.up;
      case JoystickMoveDirectional.MOVE_UP_LEFT:
        return Direction.upLeft;
      case JoystickMoveDirectional.MOVE_UP_RIGHT:
        return Direction.upRight;
      case JoystickMoveDirectional.MOVE_RIGHT:
        return Direction.right;
      case JoystickMoveDirectional.MOVE_DOWN:
        return Direction.down;
      case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
        return Direction.downRight;
      case JoystickMoveDirectional.MOVE_DOWN_LEFT:
        return Direction.downLeft;
      case JoystickMoveDirectional.MOVE_LEFT:
        return Direction.left;
      case JoystickMoveDirectional.IDLE:
        return Direction.left;
    }
  }
}

GameActionEnum getActionFromText(String txt) {
  switch (txt) {
    case 'MOVE':
      return GameActionEnum.MOVE;
    case 'ATTACK':
      return GameActionEnum.ATTACK;
    case 'RECEIVED_DAMAGE':
      return GameActionEnum.RECEIVED_DAMAGE;
    case 'PLAYER_LEAVED':
      return GameActionEnum.PLAYER_LEAVED;
  }
  return GameActionEnum.MOVE;
}

JoystickMoveDirectional getDirectionFromText(String txt) {
  switch (txt) {
    case 'LEFT':
      return JoystickMoveDirectional.MOVE_LEFT;
    case 'RIGHT':
      return JoystickMoveDirectional.MOVE_RIGHT;
    case 'UP':
      return JoystickMoveDirectional.MOVE_UP;
    case 'DOWN':
      return JoystickMoveDirectional.MOVE_DOWN;
    case 'UP_LEFT':
      return JoystickMoveDirectional.MOVE_UP_LEFT;
    case 'UP_RIGHT':
      return JoystickMoveDirectional.MOVE_UP_RIGHT;
    case 'DOWN_LEFT':
      return JoystickMoveDirectional.MOVE_DOWN_LEFT;
    case 'DOWN_RIGHT':
      return JoystickMoveDirectional.MOVE_RIGHT;
    case 'IDLE':
      return JoystickMoveDirectional.IDLE;
  }
  return JoystickMoveDirectional.IDLE;
}

class SocketMessage {
  final GameActionEnum action;
  final DateTime time;
  final SocketMessageData data;

  SocketMessage({
    required this.action,
    required this.time,
    required this.data,
  });

  SocketMessage.fromJson(Map json)
      : action = getActionFromText(json['action']),
        time = DateTime.parse(json['time']?.toString() ?? '00/00/00 00:00:00'),
        data = SocketMessageData.fromJson(json['data']);

  Map toJson() {
    Map map = {};
    map['action'] = action.toText();
    map['time'] = time.toIso8601String();
    map['data'] = data.toJson();
    return map;
  }
}

class SocketMessageData {
  final JoystickMoveDirectional direction;
  final int playerId;
  final int playerIdAttack;
  final Offset position;
  final double damage;

  SocketMessageData({
    this.direction = JoystickMoveDirectional.IDLE,
    required this.playerId,
    this.playerIdAttack = 0,
    required this.position,
    this.damage = 0,
  });

  SocketMessageData.fromJson(Map json)
      : direction = getDirectionFromText(json['direction']),
        playerId = int.tryParse(json['player_id']?.toString() ?? '') ?? 0,
        playerIdAttack =
            int.tryParse(json['player_id_attack']?.toString() ?? '') ?? 0,
        damage = double.tryParse(json['damage']?.toString() ?? '') ?? 0.0,
        position = Offset(
          double.tryParse(json['position']['x']?.toString() ?? '') ?? 0.0,
          double.tryParse(json['position']['y']?.toString() ?? '') ?? 0.0,
        );

  Map toJson() {
    Map map = {};
    map['direction'] = direction.toText();
    map['player_id'] = playerId;
    map['player_id_attack'] = playerIdAttack;
    map['damage'] = damage;
    Map p = {
      'x': position.dx,
      'y': position.dy,
    };
    map['position'] = p;
    return map;
  }
}

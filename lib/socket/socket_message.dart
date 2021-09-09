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
        break;
      case GameActionEnum.ATTACK:
        return 'ATTACK';
        break;
      case GameActionEnum.RECEIVED_DAMAGE:
        return 'RECEIVED_DAMAGE';
        break;
      case GameActionEnum.PLAYER_LEAVED:
        return 'PLAYER_LEAVED';
        break;
    }
    return '';
  }
}

extension DirectionExt on Direction {
  JoystickMoveDirectional getJoystickMoveDirectional() {
    switch (this) {
      case Direction.left:
        return JoystickMoveDirectional.MOVE_LEFT;
        break;
      case Direction.right:
        return JoystickMoveDirectional.MOVE_RIGHT;
        break;
      case Direction.up:
        return JoystickMoveDirectional.MOVE_UP;
        break;
      case Direction.down:
        return JoystickMoveDirectional.MOVE_DOWN;
        break;
      case Direction.upLeft:
        return JoystickMoveDirectional.MOVE_LEFT;
        break;
      case Direction.upRight:
        return JoystickMoveDirectional.MOVE_RIGHT;
        break;
      case Direction.downLeft:
        return JoystickMoveDirectional.MOVE_LEFT;
        break;
      case Direction.downRight:
        return JoystickMoveDirectional.MOVE_RIGHT;
        break;
    }
    return JoystickMoveDirectional.IDLE;
  }
}

extension JoystickMoveDirectionalExt on JoystickMoveDirectional {
  String toText() {
    switch (this) {
      case JoystickMoveDirectional.MOVE_LEFT:
        return 'LEFT';
        break;
      case JoystickMoveDirectional.MOVE_RIGHT:
        return 'RIGHT';
        break;
      case JoystickMoveDirectional.MOVE_UP:
        return 'UP';
        break;
      case JoystickMoveDirectional.MOVE_DOWN:
        return 'DOWN';
        break;
      case JoystickMoveDirectional.MOVE_UP_LEFT:
        return 'UP_LEFT';
        break;
      case JoystickMoveDirectional.MOVE_UP_RIGHT:
        return 'UP_RIGHT';
        break;
      case JoystickMoveDirectional.MOVE_DOWN_LEFT:
        return 'DOWN_LEFT';
        break;
      case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
        return 'DOWN_RIGHT';
        break;
      case JoystickMoveDirectional.IDLE:
        return 'IDLE';
        break;
    }
    return 'IDLE';
  }

  Direction getDirection() {
    switch (this) {
      case JoystickMoveDirectional.MOVE_UP:
        return Direction.up;
        break;
      case JoystickMoveDirectional.MOVE_UP_LEFT:
        return Direction.upLeft;
        break;
      case JoystickMoveDirectional.MOVE_UP_RIGHT:
        return Direction.upRight;
        break;
      case JoystickMoveDirectional.MOVE_RIGHT:
        return Direction.right;
        break;
      case JoystickMoveDirectional.MOVE_DOWN:
        return Direction.down;
        break;
      case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
        return Direction.downRight;
        break;
      case JoystickMoveDirectional.MOVE_DOWN_LEFT:
        return Direction.downLeft;
        break;
      case JoystickMoveDirectional.MOVE_LEFT:
        return Direction.left;
        break;
      case JoystickMoveDirectional.IDLE:
        return Direction.left;
        break;
    }
    return Direction.left;
  }
}

GameActionEnum getActionFromText(String txt) {
  switch (txt) {
    case 'MOVE':
      return GameActionEnum.MOVE;
      break;
    case 'ATTACK':
      return GameActionEnum.ATTACK;
      break;
    case 'RECEIVED_DAMAGE':
      return GameActionEnum.RECEIVED_DAMAGE;
      break;
    case 'PLAYER_LEAVED':
      return GameActionEnum.PLAYER_LEAVED;
      break;
  }
  return GameActionEnum.MOVE;
}

JoystickMoveDirectional getDirectionFromText(String txt) {
  switch (txt) {
    case 'LEFT':
      return JoystickMoveDirectional.MOVE_LEFT;
      break;
    case 'RIGHT':
      return JoystickMoveDirectional.MOVE_RIGHT;
      break;
    case 'UP':
      return JoystickMoveDirectional.MOVE_UP;
      break;
    case 'DOWN':
      return JoystickMoveDirectional.MOVE_DOWN;
      break;
    case 'UP_LEFT':
      return JoystickMoveDirectional.MOVE_UP_LEFT;
      break;
    case 'UP_RIGHT':
      return JoystickMoveDirectional.MOVE_UP_RIGHT;
      break;
    case 'DOWN_LEFT':
      return JoystickMoveDirectional.MOVE_DOWN_LEFT;
      break;
    case 'DOWN_RIGHT':
      return JoystickMoveDirectional.MOVE_RIGHT;
      break;
    case 'IDLE':
      return JoystickMoveDirectional.IDLE;
      break;
  }
  return JoystickMoveDirectional.IDLE;
}

class SocketMessage {
  GameActionEnum action;
  DateTime time;
  SocketMessageData data;

  SocketMessage({
    this.action,
    this.time,
    this.data,
  });

  SocketMessage.fromJson(Map json) {
    action = getActionFromText(json['action']);
    if (json['time'] != null) {
      time = DateTime.parse(json['time'].toString());
    }
    if (json['data'] != null) {
      data = SocketMessageData.fromJson(json['data']);
    }
  }

  Map toJson() {
    Map map = {};
    map['action'] = action.toText();
    map['time'] = time.toIso8601String();
    map['data'] = data.toJson();
    return map;
  }
}

class SocketMessageData {
  JoystickMoveDirectional direction;
  int playerId;
  int playerIdAttack;
  Offset position;
  double damage;

  SocketMessageData({
    this.direction,
    this.playerId,
    this.playerIdAttack,
    this.position,
    this.damage,
  });

  SocketMessageData.fromJson(Map json) {
    direction = getDirectionFromText(json['direction']);
    playerId = int.tryParse(json['player_id'].toString()) ?? 0;
    if (json['player_id_attack'] != null) {
      playerIdAttack = int.tryParse(json['player_id_attack'].toString()) ?? 0;
    }
    if (json['damage'] != null) {
      damage = double.tryParse(json['damage'].toString()) ?? 0.0;
    }
    if (json['position'] != null) {
      position = Offset(
        double.tryParse(json['position']['x']?.toString()) ?? 0.0,
        double.tryParse(json['position']['y']?.toString()) ?? 0.0,
      );
    }
  }
  Map toJson() {
    Map map = {};
    map['direction'] = direction.toText();
    map['player_id'] = playerId;
    map['player_id_attack'] = playerIdAttack;
    map['damage'] = damage;
    Map p = {
      'x': position?.dx ?? 0.0,
      'y': position?.dy ?? 0.0,
    };
    map['position'] = p;
    return map;
  }
}

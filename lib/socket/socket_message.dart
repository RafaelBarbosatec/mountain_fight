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
  String toText() {
    switch (this) {
      case Direction.left:
        return 'LEFT';
      case Direction.right:
        return 'RIGHT';
      case Direction.up:
        return 'UP';
      case Direction.down:
        return 'DOWN';
      case Direction.upLeft:
        return 'UP_LEFT';
      case Direction.upRight:
        return 'UP_RIGHT';
      case Direction.downLeft:
        return 'DOWN_LEFT';
      case Direction.downRight:
        return 'DOWN_RIGHT';
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

Direction? getDirectionFromText(String? txt) {
  switch (txt) {
    case 'LEFT':
      return Direction.left;
    case 'RIGHT':
      return Direction.right;
    case 'UP':
      return Direction.up;
    case 'DOWN':
      return Direction.down;
    case 'UP_LEFT':
      return Direction.upLeft;
    case 'UP_RIGHT':
      return Direction.upRight;
    case 'DOWN_LEFT':
      return Direction.downLeft;
    case 'DOWN_RIGHT':
      return Direction.downRight;
  }
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
        time =
            DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.now(),
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
  final Direction? direction;
  final int playerId;
  final int playerIdAttack;
  final Offset position;
  final double damage;

  SocketMessageData({
    this.direction,
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
          double.tryParse(json['position']?['x']?.toString() ?? '') ?? 0.0,
          double.tryParse(json['position']?['y']?.toString() ?? '') ?? 0.0,
        );

  Map toJson() {
    Map map = {};
    map['direction'] = direction?.toText() ?? 'IDLE';
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

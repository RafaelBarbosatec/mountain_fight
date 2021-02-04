import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/util/buffer_delay.dart';

abstract class ServerPlayerActions {
  void serverPlayerLeave();
  void serverReceiveDamage(double damage);
  void serverMove(
    String direction,
    Rect serverPosition,
  );
  void serverAttack(String direction);
}

mixin ServerPlayerControl on GameComponent implements ServerPlayerActions {
  static const EVENT_SOCKET_NAME = 'message';
  static const ACTION_MOVE = 'MOVE';
  static const ACTION_ATTACK = 'ATTACK';
  static const ACTION_RECEIVED_DAMAGE = 'RECEIVED_DAMAGE';
  static const ACTION_PLAYER_LEAVED = 'PLAYER_LEAVED';
  int _playerId;
  BufferDelay _bufferMoveAndAttack;
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
      double x = double.parse(data['data']['position']['x'].toString()) * tileSize;
      double y = double.parse(data['data']['position']['y'].toString()) * tileSize;
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
}

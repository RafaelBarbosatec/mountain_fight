import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/remote_player/remote_player.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/socket/socket_message.dart';
import 'package:mountain_fight/util/buffer_delay.dart';

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
/// on 29/03/22
class RemotePlayerController extends StateController<RemotePlayer> {
  static const EVENT_SOCKET_NAME = 'message';
  static const ACTION_MOVE = 'MOVE';
  static const ACTION_ATTACK = 'ATTACK';
  static const ACTION_RECEIVED_DAMAGE = 'RECEIVED_DAMAGE';
  static const ACTION_PLAYER_LEAVED = 'PLAYER_LEAVED';

  final SocketManager _socketManager;
  final BufferDelay _buffer;
  int playerId = 0;
  Direction? currentMove;

  RemotePlayerController(this._socketManager, this._buffer);

  @override
  void onReady(RemotePlayer component) {
    playerId = component.id;
    _buffer.listen(_listenBuffer);
    _setupSocket();
    super.onReady(component);
  }

  @override
  void onRemove(RemotePlayer component) {
    _socketManager.removeListen(EVENT_SOCKET_NAME, _listenMessage);
    _buffer.reset();
    super.onRemove(component);
  }

  void _setupSocket() {
    _socketManager.listen(EVENT_SOCKET_NAME, _listenMessage);
  }

  void _listenMessage(dynamic data) {
    SocketMessage msg = SocketMessage.fromJson(data);
    bool isMine = msg.data.playerId == playerId;
    if (!isMine) return;

    if (msg.action == GameActionEnum.RECEIVED_DAMAGE) {
      serverReceiveDamage(msg.data.damage);
    } else if (msg.action == GameActionEnum.PLAYER_LEAVED) {
      serverPlayerLeave();
    } else {
      _buffer.add(
        msg,
        msg.time,
      );
    }
  }

  void _listenBuffer(dynamic data) {
    SocketMessage event = data;
    if (event.action == GameActionEnum.MOVE) {
      double x = event.data.position.dx * tileSize;
      double y = event.data.position.dy * tileSize;
      Rect serverPosition = Rect.fromLTWH(
        x,
        y,
        component!.width,
        component!.height,
      );
      serverMove(event.data.direction, serverPosition);
    }
    if (event.action == GameActionEnum.ATTACK) {
      component?.execAttack(event.data.direction);
    }
  }

  void serverPlayerLeave() {
    if (component?.isDead == false) {
      component?.die();
    }
  }

  void serverReceiveDamage(double damage) {
    if (component?.isDead == false) {
      if (component!.life > 0) {
        component!.life -= damage;
        component?.execShowDamage(damage);
        if (component!.life <= 0) {
          component!.die();
        }
      }
    }
  }

  void serverMove(Direction? direction, Rect serverPosition) {
    currentMove = direction;

    /// Corrige posição se ele estiver muito diferente da do server
    Vector2 p = Vector2(serverPosition.left, serverPosition.top);
    double dist = p.distanceTo(component!.position);

    if (dist > (tileSize * 0.5)) {
      component!.position = serverPosition.positionVector2;
    }
  }

  @override
  void update(double dt) {
    _move(currentMove);
  }

  void _move(Direction? direction) {
    if (component == null) {
      return;
    }
    double speed = component!.speed;
    switch (direction) {
      case Direction.left:
        component!.moveLeft(speed);
        break;
      case Direction.right:
        component!.moveRight(speed);
        break;
      case Direction.upRight:
        double speedDiagonal = (speed * Movement.REDUCTION_SPEED_DIAGONAL);
        component!.moveUpRight(
          speedDiagonal,
          speedDiagonal,
        );
        break;
      case Direction.downRight:
        double speedDiagonal = (speed * Movement.REDUCTION_SPEED_DIAGONAL);
        component!.moveDownRight(
          speedDiagonal,
          speedDiagonal,
        );

        break;
      case Direction.downLeft:
        double speedDiagonal = (speed * Movement.REDUCTION_SPEED_DIAGONAL);
        component!.moveDownLeft(
          speedDiagonal,
          speedDiagonal,
        );
        break;
      case Direction.upLeft:
        double speedDiagonal = (speed * Movement.REDUCTION_SPEED_DIAGONAL);
        component!.moveUpLeft(
          speedDiagonal,
          speedDiagonal,
        );
        break;
      case Direction.up:
        component!.moveUp(speed);
        break;
      case Direction.down:
        component!.moveDown(speed);
        break;
      default:
        component!.idle();
    }
  }
}
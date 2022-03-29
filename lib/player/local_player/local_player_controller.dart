import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/local_player/local_player.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/socket/socket_message.dart';

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
class LocalPlayerController extends StateController<LocalPlayer> {
  final double maxStamina = 100;
  double stamina = 100;
  double maxLife = 100;
  double life = 100;
  Direction? cDirection;

  final SocketManager _socketManager;

  LocalPlayerController(this._socketManager);

  @override
  void onReady(LocalPlayer component) {
    life = component.life;
    maxLife = component.maxLife;
    super.onReady(component);
  }

  @override
  void update(double dt) {
    life = component?.life ?? 0;
    if (component?.isDead == false) {
      _verifyStamina(dt);
    }
  }

  void _verifyStamina(double dt) {
    if (component?.checkInterval('STAMINA', 150, dt) == true) {
      stamina += 2;
      if (stamina > 100) {
        stamina = 100;
      }
      notifyListeners();
    }
  }

  void decrementStamina(int i) {
    stamina -= i;
    if (stamina < 0) {
      stamina = 0;
    }
    notifyListeners();
  }

  void joystickAction(JoystickActionEvent action) {
    if (action.id == LogicalKeyboardKey.space.keyId &&
        action.event == ActionEvent.DOWN) {
      _tryExecAttack();
    }
    if (action.id == 0 && action.event == ActionEvent.DOWN) {
      _tryExecAttack();
    }
  }

  void _tryExecAttack() {
    if (stamina < 25 || component?.isDead == true) {
      return;
    }
    decrementStamina(25);

    _socketManager.send(
      'message',
      SocketMessage(
        time: DateTime.now(),
        action: GameActionEnum.ATTACK,
        data: SocketMessageData(
          playerId: component!.id,
          direction: component!.lastDirection,
          position: Offset(
            (component!.position.x / tileSize),
            (component!.position.y / tileSize),
          ),
        ),
      ).toJson(),
    );

    component?.execAttack();
  }

  void receiveDamage(double damage, dynamic from) {
    _socketManager.send(
      'message',
      SocketMessage(
        time: DateTime.now(),
        action: GameActionEnum.RECEIVED_DAMAGE,
        data: SocketMessageData(
          playerId: component!.id,
          playerIdAttack: from,
          damage: damage,
          position: Offset(
            (component!.position.x / tileSize),
            (component!.position.y / tileSize),
          ),
        ),
      ).toJson(),
    );
    notifyListeners();
  }

  void onMove(double speed, Direction direction) {
    if (speed > 0) {
      _sendMove(direction);
    } else {
      _sendMove(null);
    }
  }

  void _sendMove(Direction? direction) {
    if (direction != cDirection) {
      cDirection = direction;
      _socketManager.send(
        'message',
        SocketMessage(
          time: DateTime.now(),
          action: GameActionEnum.MOVE,
          data: SocketMessageData(
            playerId: component!.id,
            direction: cDirection,
            position: Offset(
              (component!.x / tileSize),
              (component!.y / tileSize),
            ),
          ),
        ).toJson(),
      );
    }
  }

  void idle() {
    _sendMove(null);
  }
}

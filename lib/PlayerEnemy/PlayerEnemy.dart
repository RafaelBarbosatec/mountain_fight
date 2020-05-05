import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/socket/SocketManager.dart';

class PlayerEnemy extends SimpleEnemy {
  static const REDUCTION_SPEED_DIAGONAL = 0.7;
  final int id;
  final String nick;

  String currentMove = 'IDLE';

  TextConfig _textConfig;

  PlayerEnemy(
      this.id, this.nick, Position initPosition, SpriteSheet spriteSheet)
      : super(
          initPosition: initPosition,
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          animationIdleTop: spriteSheet.createAnimation(0, stepTime: 0.1),
          animationIdleBottom: spriteSheet.createAnimation(1, stepTime: 0.1),
          animationIdleLeft: spriteSheet.createAnimation(2, stepTime: 0.1),
          animationIdleRight: spriteSheet.createAnimation(3, stepTime: 0.1),
          animationRunTop: spriteSheet.createAnimation(4, stepTime: 0.1),
          animationRunBottom: spriteSheet.createAnimation(5, stepTime: 0.1),
          animationRunLeft: spriteSheet.createAnimation(6, stepTime: 0.1),
          animationRunRight: spriteSheet.createAnimation(7, stepTime: 0.1),
          life: 200,
          speed: tileSize / 0.22,
          collision: Collision(
            height: (tileSize * 0.5),
            width: (tileSize * 0.6),
          ),
        ) {
    _textConfig = TextConfig(
      fontSize: height / 3.5,
    );
    SocketManager().listen('message', (data) {
      if (data['data']['player_id'] == id) {
        String action = data['action'];
        if (action == 'MOVE') {
          currentMove = data['data']['direction'];
        }
      }
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    _move(currentMove);
  }

  void _move(move) {
    switch (move) {
      case 'LEFT':
        this.customMoveLeft(speed * dtUpdate);
        break;
      case 'RIGHT':
        this.customMoveRight(speed * dtUpdate);
        break;
      case 'UP_RIGHT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        customMoveRight(
          speedDiagonal,
        );
        customMoveTop(speedDiagonal, addAnimation: false);
        break;
      case 'DOWN_RIGHT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        customMoveRight(
          speedDiagonal,
        );
        customMoveBottom(speedDiagonal, addAnimation: false);
        break;
      case 'DOWN_LEFT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        customMoveLeft(
          speedDiagonal,
        );
        customMoveBottom(speedDiagonal, addAnimation: false);
        break;
      case 'UP_LEFT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        customMoveLeft(
          speedDiagonal,
        );
        customMoveTop(speedDiagonal, addAnimation: false);
        break;
        break;
      case 'UP':
        this.customMoveTop(speed * dtUpdate);
        break;
      case 'DOWN':
        this.customMoveBottom(speed * dtUpdate);
        break;
      case 'IDLE':
        this.idle();
        break;
    }
  }

  @override
  void render(Canvas canvas) {
    _textConfig.withColor(Colors.white).render(
          canvas,
          nick,
          Position(position.left + 2, position.top - 20),
        );
    super.render(canvas);
  }
}

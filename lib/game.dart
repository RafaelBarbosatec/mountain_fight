import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flutter/material.dart';
import 'package:mountain_fight/interface/player_interface.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/game_player.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';
import 'package:mountain_fight/remote_player/remote_player.dart';
import 'package:mountain_fight/socket/SocketManager.dart';

class Game extends StatefulWidget {
  final int idCharacter;
  final int playerId;
  final String nick;
  final Position position;
  final List<dynamic> playersOn;

  const Game(
      {Key key,
      this.idCharacter,
      this.position,
      this.playerId,
      this.nick,
      this.playersOn})
      : super(key: key);
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> implements GameListener {
  GameController _controller = GameController();
  bool firstUpdate = false;
  @override
  void initState() {
    _controller.setListener(this);
    SocketManager().listen('message', (data) {
      if (data['action'] == 'PLAYER_JOIN' &&
          data['data']['id'] != widget.playerId) {
        Position personPosition = Position(
          double.parse(data['data']['position']['x'].toString()) * tileSize,
          double.parse(data['data']['position']['y'].toString()) * tileSize,
        );
        var enemy = RemotePlayer(
          data['data']['id'],
          data['data']['nick'],
          personPosition,
          _getSprite(data['data']['skin'] ?? 0),
        );
        _controller.addGameComponent(enemy);
        _controller.addGameComponent(AnimatedObjectOnce(
          animation: FlameAnimation.Animation.sequenced(
            "smoke_explosin.png",
            6,
            textureWidth: 16,
            textureHeight: 16,
          ),
          position: Rect.fromLTRB(personPosition.x, personPosition.y, 32, 32),
        ));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    SocketManager().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      tileSize = max(constraints.maxHeight, constraints.maxWidth) / 20;

      return BonfireTiledWidget(
        joystick: Joystick(
          keyboardEnable: true,
          directional: JoystickDirectional(
            spriteKnobDirectional: Sprite('joystick_knob.png'),
            spriteBackgroundDirectional: Sprite('joystick_background.png'),
            size: 100,
          ),
          actions: [
            JoystickAction(
              actionId: 0,
              sprite: Sprite('joystick_atack.png'),
              spritePressed: Sprite('joystick_atack_selected.png'),
              size: 80,
              margin: EdgeInsets.only(bottom: 50, right: 50),
            ),
          ],
        ),
        player: GamePlayer(
          widget.playerId,
          widget.nick,
          Position(widget.position.x * tileSize, widget.position.y * tileSize),
          _getSprite(widget.idCharacter),
        ),
        interface: PlayerInterface(),
        map: TiledWorldMap('tile/map.json',
            forceTileSize: Size(tileSize, tileSize)),
        constructionModeColor: Colors.black,
        collisionAreaColor: Colors.purple.withOpacity(0.4),
        gameController: _controller,
        cameraMoveOnlyMapArea: true,
      );
    });
  }

  SpriteSheet _getSprite(int index) {
    switch (index) {
      case 0:
        return SpriteSheetHero.hero1;
        break;
      case 1:
        return SpriteSheetHero.hero2;
        break;
      case 2:
        return SpriteSheetHero.hero3;
        break;
      case 3:
        return SpriteSheetHero.hero4;
        break;
      case 4:
        return SpriteSheetHero.hero5;
        break;
      default:
        return SpriteSheetHero.hero1;
    }
  }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {
    if (!firstUpdate) {
      firstUpdate = true;
      _addPlayersOn();
    }
  }

  void _addPlayersOn() {
    widget.playersOn.forEach((player) {
      if (player != null && player['id'] != widget.playerId) {
        var enemy = RemotePlayer(
          player['id'],
          player['nick'],
          Position(
            double.parse(player['position']['x'].toString()) * tileSize,
            double.parse(player['position']['y'].toString()) * tileSize,
          ),
          _getSprite(player['skin'] ?? 0),
        );
        enemy.life = double.parse(player['life'].toString());
        _controller.addGameComponent(enemy);
      }
    });
  }
}

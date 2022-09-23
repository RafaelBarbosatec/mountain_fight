import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/player/local_player/local_player.dart';
import 'package:mountain_fight/player/remote_player/remote_player.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';
import 'package:mountain_fight/socket/SocketManager.dart';

import 'decoration/tree.dart';
import 'interface/interface_overlay.dart';

class Game extends StatefulWidget {
  final int idCharacter;
  final int playerId;
  final String nick;
  final Vector2 position;
  final List<dynamic> playersOn;

  const Game({
    Key? key,
    required this.idCharacter,
    required this.position,
    required this.playerId,
    required this.nick,
    required this.playersOn,
  }) : super(key: key);
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  GameController _controller = GameController();
  bool firstUpdate = false;
  late SocketManager _socketManager;
  @override
  void initState() {
    _socketManager = BonfireInjector.instance.get();
    _setupSocketControl();
    super.initState();
  }

  @override
  void dispose() {
    _socketManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      tileSize = max(constraints.maxHeight, constraints.maxWidth) / 30;
      return BonfireWidget(
        gameController: _controller,
        joystick: Joystick(
          keyboardConfig: KeyboardConfig(),
          directional: JoystickDirectional(
            spriteKnobDirectional: Sprite.load('joystick_knob.png'),
            spriteBackgroundDirectional: Sprite.load('joystick_background.png'),
            size: 100,
          ),
          actions: [
            JoystickAction(
              actionId: 0,
              sprite: Sprite.load('joystick_atack.png'),
              spritePressed: Sprite.load('joystick_atack_selected.png'),
              size: 80,
              margin: EdgeInsets.only(bottom: 50, right: 50),
            ),
          ],
        ),
        player: LocalPlayer(
          widget.playerId,
          widget.nick,
          Vector2(widget.position.x * tileSize, widget.position.y * tileSize),
          _getSprite(widget.idCharacter),
        ),
        map: WorldMapByTiled(
          'tile/map.json',
          forceTileSize: Vector2.all(tileSize),
          objectsBuilder: {
            'tree': (p) => Tree(p.position),
          },
        ),
        constructionModeColor: Colors.black,
        collisionAreaColor: Colors.purple.withOpacity(0.4),
        cameraConfig: CameraConfig(
          moveOnlyMapArea: true,
          smoothCameraEnabled: true,
          smoothCameraSpeed: 2.0,
        ),
        initialActiveOverlays: ['barLife'],
        overlayBuilderMap: {
          'barLife': (_, game) => InterfaceOverlay(
                gameController: _controller,
              ),
        },
        onReady: (game) {
          _addPlayersOn();
        },
      );
    });
  }

  SpriteSheet _getSprite(int index) {
    switch (index) {
      case 0:
        return SpriteSheetHero.hero1;
      case 1:
        return SpriteSheetHero.hero2;
      case 2:
        return SpriteSheetHero.hero3;
      case 3:
        return SpriteSheetHero.hero4;
      case 4:
        return SpriteSheetHero.hero5;
      default:
        return SpriteSheetHero.hero1;
    }
  }

  void _addPlayersOn() {
    widget.playersOn.forEach((player) {
      if (player != null && player['id'] != widget.playerId) {
        _addRemotePlayer(player);
      }
    });
  }

  void _setupSocketControl() {
    _socketManager.listen('message', (data) {
      if (data['action'] == 'PLAYER_JOIN' &&
          data['data']['id'] != widget.playerId) {
        _addRemotePlayer(data['data']);
      }
    });
  }

  void _addRemotePlayer(Map data) {
    Vector2 personPosition = Vector2(
      double.parse(data['position']['x'].toString()) * tileSize,
      double.parse(data['position']['y'].toString()) * tileSize,
    );

    var enemy = RemotePlayer(
      data['id'],
      data['nick'],
      personPosition,
      _getSprite(data['skin'] ?? 0),
    );
    if (data['life'] != null) {
      enemy.update(double.tryParse(data['life'].toString()) ?? 0.0);
    }
    _controller.addGameComponent(enemy);
    _controller.addGameComponent(
      AnimatedObjectOnce(
        animation: SpriteSheetHero.smokeExplosion,
        size: Vector2.all(tileSize),
        position: Vector2(
          personPosition.x,
          personPosition.y,
        ),
      ),
    );
  }
}

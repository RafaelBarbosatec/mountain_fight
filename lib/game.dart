import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/PlayerEnemy/PlayerEnemy.dart';
import 'package:mountain_fight/interface/player_interface.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/map/mountain_map.dart';
import 'package:mountain_fight/player/game_player.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';
import 'package:mountain_fight/socket/SocketManager.dart';

class Game extends StatefulWidget {
  final int idCharacter;
  final int playerId;
  final String nick;
  final Position position;

  const Game(
      {Key key, this.idCharacter, this.position, this.playerId, this.nick})
      : super(key: key);
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> implements GameListener {
  GameController _controller = GameController();
  @override
  void initState() {
    _controller.setListener(this);
    SocketManager().listen('message', (data) {
      if (data['action'] == 'PLAYER_JOIN' &&
          data['data']['id'] != widget.playerId) {
        _controller.addEnemy(PlayerEnemy(
          data['data']['id'],
          data['data']['nick'],
          Position(
            double.parse(data['data']['position']['x'].toString()) * tileSize,
            double.parse(data['data']['position']['y'].toString()) * tileSize,
          ),
          data['data']['skin'] ?? _getSprite(0),
        ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 800,
      child: LayoutBuilder(builder: (context, constraints) {
        tileSize = ((constraints.maxHeight < constraints.maxWidth)
                ? constraints.maxHeight
                : constraints.maxWidth) /
            11;
        tileSize = tileSize.roundToDouble();

        return BonfireWidget(
          joystick: Joystick(
            pathSpriteBackgroundDirectional: 'joystick_background.png',
            pathSpriteKnobDirectional: 'joystick_knob.png',
            sizeDirectional: 100,
            actions: [
              JoystickAction(
                actionId: 0,
                pathSprite: 'joystick_atack.png',
                pathSpritePressed: 'joystick_atack_selected.png',
                size: 80,
                margin: EdgeInsets.only(bottom: 50, right: 50),
              ),
            ],
          ),
          player: GamePlayer(
            widget.playerId,
            widget.nick,
            Position(
                widget.position.x * tileSize, widget.position.y * tileSize),
            _getSprite(widget.idCharacter),
          ),
          interface: PlayerInterface(),
          map: MountainMap.map(),
          decorations: MountainMap.decorations(),
          constructionModeColor: Colors.black,
          collisionAreaColor: Colors.purple.withOpacity(0.4),
          gameController: _controller,
//      showCollisionArea: true,
        );
      }),
    );
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
  void changeCountLiveEnemies(int count) {
    // TODO: implement changeCountLiveEnemies
  }

  @override
  void updateGame() {
    // TODO: implement updateGame
  }
}

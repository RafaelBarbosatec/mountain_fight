import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/interface/player_interface.dart';
import 'package:mountain_fight/main.dart';
import 'package:mountain_fight/map/mountain_map.dart';
import 'package:mountain_fight/player/game_player.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';

class Game extends StatefulWidget {
  final int idCharacter;

  const Game({Key key, this.idCharacter}) : super(key: key);
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
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
            Position(5 * tileSize, 5 * tileSize),
            _getSprite(),
          ),
          interface: PlayerInterface(),
          map: MountainMap.map(),
          decorations: MountainMap.decorations(),
          constructionModeColor: Colors.black,
          collisionAreaColor: Colors.purple.withOpacity(0.4),
//      showCollisionArea: true,
        );
      }),
    );
  }

  SpriteSheet _getSprite() {
    switch (widget.idCharacter) {
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
}

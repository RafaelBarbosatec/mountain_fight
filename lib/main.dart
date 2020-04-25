import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/interface/player_interface.dart';
import 'package:mountain_fight/mountain_map.dart';
import 'package:mountain_fight/player/game_player.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';

double tileSize;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.setLandscape();
  await Flame.util.fullScreen();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(fontFamily: 'Normal'),
        ),
      ),
      home: Game(),
    ),
  );
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    tileSize = ((sizeScreen.height < sizeScreen.width)
            ? sizeScreen.height
            : sizeScreen.width) /
        15;
    tileSize = tileSize.round().toDouble();
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
        SpriteSheetHero.hero1,
      ),
      interface: PlayerInterface(),
      map: MountainMap.map(),
      decorations: MountainMap.decorations(),
      constructionModeColor: Colors.black,
      collisionAreaColor: Colors.purple.withOpacity(0.4),
//      constructionMode: true,
//      showCollisionArea: true,
    );
  }
}

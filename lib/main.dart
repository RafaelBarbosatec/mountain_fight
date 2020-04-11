import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/MountainMap.dart';

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
      map: MountainMap.map(),
      decorations: [],
      enemies: [],
      constructionMode: true,
    );
  }
}

import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/person_select.dart';
import 'package:mountain_fight/player/local_player/local_player_controller.dart';
import 'package:mountain_fight/socket/SocketManager.dart';

import 'player/sprite_sheet_hero.dart';

double tileSize = 35;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpriteSheetHero.load();
  if (!kIsWeb) {
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
  }

  SocketManager.configure('http://mountainfight.herokuapp.com');
  BonfireInjector.instance.put((i) => SocketManager());
  BonfireInjector.instance.put((i) => LocalPlayerController(i.get()));

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersonSelect(),
    ),
  );
}

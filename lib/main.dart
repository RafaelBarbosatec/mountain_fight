import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/person_select.dart';
import 'package:mountain_fight/player/local_player/local_player_controller.dart';
import 'package:mountain_fight/player/remote_player/remote_player_controller.dart';
import 'package:mountain_fight/socket/SocketManager.dart';
import 'package:mountain_fight/util/buffer_delay.dart';

import 'player/sprite_sheet_hero.dart';

double tileSize = 35;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpriteSheetHero.load();
  if (!kIsWeb) {
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
  }

  final socketManager = SocketManager('http://mountainfight.herokuapp.com');
  BonfireInjector.instance.put((i) => socketManager);
  BonfireInjector.instance.put((i) => LocalPlayerController(i.get()));
  BonfireInjector.instance.putFactory((i) => BufferDelay(200));
  BonfireInjector.instance.putFactory(
    (i) => RemotePlayerController(i.get(), i.get()),
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersonSelect(),
    ),
  );
}

import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/person_select.dart';
import 'package:mountain_fight/socket/SocketManager.dart';

const double tileSize = 32;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Flame.util.setLandscape();
    await Flame.util.fullScreen();
  }

  SocketManager.configure('http://mountainfight.herokuapp.com');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersonSelect(),
    ),
  );
}

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/person_select.dart';
import 'package:mountain_fight/socket/SocketManager.dart';

double tileSize;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.util.setLandscape();
  await Flame.util.fullScreen();

  SocketManager.configure('http://mountainfight.omv.jandersonlemos.com');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(fontFamily: 'Normal'),
        ),
      ),
      home: PersonSelect(),
    ),
  );
}

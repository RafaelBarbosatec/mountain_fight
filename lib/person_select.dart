import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/game.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';
import 'package:mountain_fight/socket/SocketManager.dart';

class PersonSelect extends StatefulWidget {
  @override
  _PersonSelectState createState() => _PersonSelectState();
}

class _PersonSelectState extends State<PersonSelect> {
  int count = 0;
  List<SpriteSheet> sprites = List();
  bool loading = false;
  String nick;
  String statusServer = "CONNECTING";

  @override
  void initState() {
    nick = 'Nick${Random().nextInt(100)}';
    sprites.add(SpriteSheetHero.hero1);
    sprites.add(SpriteSheetHero.hero2);
    sprites.add(SpriteSheetHero.hero3);
    sprites.add(SpriteSheetHero.hero4);
    sprites.add(SpriteSheetHero.hero5);

    SocketManager().listenConnection((_) {
      setState(() {
        statusServer = 'CONNECTED';
      });
    });
    SocketManager().listenError((_) {
      setState(() {
        statusServer = 'ERROR: $_';
      });
    });

    SocketManager().listen('message', (data) {
      if (data is Map && data['action'] == 'PLAYER_JOIN') {
        setState(() {
          loading = false;
        });
        if (data['data']['nick'] == nick) {
          SocketManager().cleanListeners();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Game(
                    playersOn: data['data']['playersON'],
                    nick: nick,
                    playerId: data['data']['id'],
                    idCharacter: count,
                    position: Position(
                      double.parse(data['data']['position']['x'].toString()),
                      double.parse(data['data']['position']['y'].toString()),
                    ))),
          );
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[800],
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Select your character",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                Expanded(
                  child: _buildPersons(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: RaisedButton(
                          color: Colors.orange,
                          child: Text(
                            'ENTRAR',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onPressed:
                              statusServer == 'CONNECTED' ? _goGame : null,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (loading)
              InkWell(
                onTap: () {},
                child: Container(
                  color: Colors.white.withOpacity(0.9),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Loading")
                      ],
                    ),
                  ),
                ),
              ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  statusServer,
                  style: TextStyle(fontSize: 9, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPersons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: count == 0
              ? SizedBox.shrink()
              : Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: RaisedButton(
                      color: Colors.blue,
                      padding: EdgeInsets.all(0),
                      child: Center(
                          child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      )),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      onPressed: _previous,
                    ),
                  ),
                ),
        ),
        Expanded(
          child: Center(
            child: Flame.util.animationAsWidget(Position(100, 100),
                sprites[count].createAnimation(5, stepTime: 0.1)),
          ),
        ),
        Expanded(
          child: count == sprites.length - 1
              ? SizedBox.shrink()
              : Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: RaisedButton(
                      color: Colors.blue,
                      padding: EdgeInsets.all(0),
                      child: Center(
                          child: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      )),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      onPressed: _next,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  void _next() {
    if (count < sprites.length - 1) {
      setState(() {
        count++;
      });
    }
  }

  void _previous() {
    if (count > 0) {
      setState(() {
        count--;
      });
    }
  }

  void _goGame() {
    if (SocketManager().connected) {
      setState(() {
        loading = true;
      });
      _joinGame();
    } else {
      print('Server não conectado.');
    }
  }

  void _joinGame() {
    SocketManager().send('message', {
      'action': 'CREATE',
      'data': {'nick': nick, 'skin': count}
    });
  }
}

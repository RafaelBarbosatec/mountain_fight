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
  List<SpriteSheet> sprites = [];
  bool loading = false;
  String statusServer = "CONNECTING";
  PageController _pageController = PageController();
  TextEditingController _textEditingController = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey();

  @override
  void initState() {
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

    SocketManager().listen('message', _listen);

    SocketManager().connect();

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
                  flex: 2,
                  child: _buildPersons(),
                ),
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _form,
                        child: SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'What your nick?',
                            ),
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Nick required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
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
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onPressed: statusServer == 'CONNECTED'
                                    ? _goGame
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
    return Center(
      child: SingleChildScrollView(
        child: Row(
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
                            borderRadius: BorderRadius.circular(25),
                          ),
                          onPressed: _previous,
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: sprites.length,
                  onPageChanged: (index) {
                    setState(() {
                      count = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return SpriteAnimationWidget(
                      animation: sprites[index].createAnimation(
                        row: 5,
                        stepTime: 0.1,
                      ),
                      anchor: Anchor.center,
                    );
                  },
                ),
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
                            borderRadius: BorderRadius.circular(25),
                          ),
                          onPressed: _next,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _next() {
    if (count < sprites.length - 1) {
      _pageController.animateToPage(
        count + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    }
  }

  void _previous() {
    if (count > 0) {
      _pageController.animateToPage(
        count - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    }
  }

  void _goGame() {
    if (_form.currentState.validate()) {
      if (SocketManager().connected) {
        setState(() {
          loading = true;
        });
        _joinGame();
      } else {
        print('Server não conectado.');
      }
    }
  }

  void _joinGame() {
    SocketManager().send('message', {
      'action': 'CREATE',
      'data': {'nick': _textEditingController.text, 'skin': count}
    });
  }

  void _listen(data) {
    if (data is Map && data['action'] == 'PLAYER_JOIN') {
      setState(() {
        loading = false;
      });
      if (data['data']['nick'] == _textEditingController.text) {
        SocketManager().cleanListeners();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Game(
              playersOn: data['data']['playersON'],
              nick: _textEditingController.text,
              playerId: data['data']['id'],
              idCharacter: count,
              position: Vector2(
                double.parse(data['data']['position']['x'].toString()),
                double.parse(data['data']['position']['y'].toString()),
              ),
            ),
          ),
        );
      }
    }
  }
}

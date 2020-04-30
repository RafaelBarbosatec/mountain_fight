import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/game.dart';
import 'package:mountain_fight/player/sprite_sheet_hero.dart';
import 'package:mountain_fight/widgets/button_small.dart';

class PersonSelect extends StatefulWidget {
  @override
  _PersonSelectState createState() => _PersonSelectState();
}

class _PersonSelectState extends State<PersonSelect> {
  int count = 0;
  List<SpriteSheet> sprites = List();

  @override
  void initState() {
    sprites.add(SpriteSheetHero.hero1);
    sprites.add(SpriteSheetHero.hero2);
    sprites.add(SpriteSheetHero.hero3);
    sprites.add(SpriteSheetHero.hero4);
    sprites.add(SpriteSheetHero.hero5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[800],
      body: SafeArea(
        child: Column(
          children: <Widget>[
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
                    child: ButtonSmall(
                      size: 200,
                      pathSelected: 'assets/images/bottom_large_green2.png',
                      pathUnSelected: 'assets/images/bottom_large_green1.png',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Game(
                                    idCharacter: count,
                                  )),
                        );
                      },
                    ),
                  ),
                ],
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
                  child: ButtonSmall(
                    size: 50,
                    pathSelected: 'assets/images/bottom_small_blue2.png',
                    pathUnSelected: 'assets/images/bottom_small_blue1.png',
                    onPress: () {
                      _previous();
                    },
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
                  child: ButtonSmall(
                    size: 50,
                    pathSelected: 'assets/images/bottom_small_blue2.png',
                    pathUnSelected: 'assets/images/bottom_small_blue1.png',
                    onPress: () {
                      _next();
                    },
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
}

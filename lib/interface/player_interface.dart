import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/player/game_player.dart';

class PlayerInterface extends GameInterface {
  static int countEmotes = 10;
  SpriteSheet spriteSheetEmotes = SpriteSheet(
    imageName: 'emotes/emotes1.png',
    textureWidth: 32,
    textureHeight: 32,
    columns: 8,
    rows: countEmotes,
  );
  double sizeButtonEmotes = 50;
  double marginButtonEmotes = 10;
  Rect rectButtonEmotes;
  Sprite spriteButtonEmotes = Sprite('emote.png');

  @override
  void update(double t) {
    super.update(t);
  }

  @override
  void render(Canvas canvas) {
    if (rectButtonEmotes != null)
      spriteButtonEmotes.renderRect(canvas, rectButtonEmotes);
    super.render(canvas);
  }

  @override
  void resize(Size size) {
    rectButtonEmotes = Rect.fromLTWH(
      size.width - sizeButtonEmotes - marginButtonEmotes,
      marginButtonEmotes,
      sizeButtonEmotes,
      sizeButtonEmotes,
    );
    super.resize(size);
  }

  void onTapDown(TapDownDetails details) {
    if (rectButtonEmotes != null &&
        rectButtonEmotes.contains(details.globalPosition)) {
      _showDialog();
    }
  }

  void _showDialog() {
    showDialog(
      context: gameRef.context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topLeft,
          child: Container(
            height: 50,
            margin: EdgeInsets.all(15),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: ListView(
                padding: EdgeInsets.only(top: 6, bottom: 6, right: 20),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(countEmotes, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (gameRef.player != null) {
                        (gameRef.player as GamePlayer)
                            .showEmote(spriteSheetEmotes.createAnimation(
                          index,
                          stepTime: 0.1,
                        ));
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      margin: EdgeInsets.only(left: 20),
                      child: Flame.util.animationAsWidget(
                          Position(32, 32),
                          spriteSheetEmotes.createAnimation(index,
                              stepTime: 0.1)),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

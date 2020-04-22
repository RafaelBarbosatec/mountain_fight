import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/player/game_player.dart';

class PlayerInterface extends GameInterface {
  OverlayEntry _overlayEntryEmotes;
  static int countEmotes = 10;
  SpriteSheet spriteSheetEmotes = SpriteSheet(
    imageName: 'emotes/emotes1.png',
    textureWidth: 32,
    textureHeight: 32,
    columns: 8,
    rows: countEmotes,
  );

  @override
  void resize(Size size) {
    add(InterfaceComponent(
        sprite: Sprite('emote.png'),
        width: 32,
        height: 32,
        id: 1,
        position: Position(size.width - 42, 10),
        onTapComponent: () {
          _showDialog();
        }));
    super.resize(size);
  }

  void _showDialog() {
    if (_overlayEntryEmotes == null) {
      _overlayEntryEmotes = OverlayEntry(
          builder: (context) => Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: ListView(
                      padding: EdgeInsets.only(top: 6, bottom: 6, right: 20),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(countEmotes, (index) {
                        return InkWell(
                          onTap: () {
                            _overlayEntryEmotes.remove();
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
              ));
    }
    Overlay.of(gameRef.context).insert(_overlayEntryEmotes);
  }
}

import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:mountain_fight/interface/bar_life_component.dart';
import 'package:mountain_fight/player/game_player.dart';
import 'package:mountain_fight/player/remote_player.dart';

class PlayerInterface extends GameInterface {
  OverlayEntry _overlayEntryEmotes;
  int countEnemy = 0;
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
    add(
      InterfaceComponent(
        sprite: Sprite('emote.png'),
        width: 32,
        height: 32,
        id: 1,
        position: Position(size.width - 42, 10),
        onTapComponent: () {
          _showDialog();
        },
      ),
    );
    addNicks(size);
    add(BarLifeComponent());
    super.resize(size);
  }

  void addNicks(Size size) {
    add(TextInterfaceComponent(
        text: _getEnemiesName(),
        width: 32,
        height: 32,
        id: 2,
        position: Position(size.width - 60, 50),
        textConfig: TextConfig(color: Colors.white, fontSize: 13),
        onTapComponent: () {
          _showDialog();
        }));
  }

  @override
  void update(double t) {
    if (gameRef.livingEnemies().length != countEnemy && gameRef.size != null) {
      addNicks(gameRef.size);
    }
    super.update(t);
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
                              (gameRef.player as GamePlayer).showEmote(spriteSheetEmotes.createAnimation(
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
                                Position(32, 32), spriteSheetEmotes.createAnimation(index, stepTime: 0.1)),
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

  String _getEnemiesName() {
    countEnemy = gameRef.livingEnemies().length;
    String names = '';
    gameRef.livingEnemies().forEach((enemy) {
      names += '${(enemy as RemotePlayer).nick}\n';
    });
    return names;
  }
}

import 'dart:ui';

import 'package:bonfire/bonfire.dart';

class SpriteSheetHero {
  static SpriteSheet hero1;
  static SpriteSheet hero2;
  static SpriteSheet hero3;
  static SpriteSheet hero4;
  static SpriteSheet hero5;
  static SpriteSheet spriteSheetEmotes;

  static load() async {
    hero1 = await _create('heroes/hero1.png');
    hero2 = await _create('heroes/hero2.png');
    hero3 = await _create('heroes/hero3.png');
    hero4 = await _create('heroes/hero4.png');
    hero5 = await _create('heroes/hero5.png');
    spriteSheetEmotes =
        await _create('emotes/emotes1.png', rows: 10, columns: 8);
  }

  static Future<SpriteSheet> _create(String path,
      {int columns = 3, int rows = 8}) async {
    Image image = await Flame.images.load(path);
    return SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: columns,
      rows: rows,
    );
  }

  static Future<SpriteAnimation> get smokeExplosion => SpriteAnimation.load(
        "smoke_explosin.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          textureSize: Vector2(16, 16),
          stepTime: 0.1,
        ),
      );

  static Future<SpriteAnimation> get attackAxe => SpriteAnimation.load(
        "axe_spin_atack.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          textureSize: Vector2(148, 148),
          stepTime: 0.05,
        ),
      );
}

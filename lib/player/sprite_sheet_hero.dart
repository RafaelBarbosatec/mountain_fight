import 'package:bonfire/bonfire.dart';

class SpriteSheetHero {
  static SpriteSheet _create(String path) {
    return SpriteSheet(
      imageName: path,
      textureWidth: 32,
      textureHeight: 32,
      columns: 3,
      rows: 8,
    );
  }

  static SpriteSheet get hero1 => _create('heroes/hero1.png');
  static SpriteSheet get hero2 => _create('heroes/hero2.png');
  static SpriteSheet get hero3 => _create('heroes/hero3.png');
  static SpriteSheet get hero4 => _create('heroes/hero4.png');
  static SpriteSheet get hero5 => _create('heroes/hero5.png');
}

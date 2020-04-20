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
}

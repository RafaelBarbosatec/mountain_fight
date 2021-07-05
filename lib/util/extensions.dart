import 'package:bonfire/bonfire.dart';

extension DirectionExtensions on Direction {
  String getName() {
    return this.toString().replaceAll('Direction.', '');
  }
}

extension StringExtensions on String {
  Direction getDirectionEnum() {
    switch (this) {
      case 'left':
        return Direction.left;
        break;
      case 'right':
        return Direction.right;
        break;
      case 'up':
        return Direction.up;
        break;
      case 'down':
        return Direction.down;
        break;
      default:
        return Direction.left;
    }
  }
}

import 'package:bonfire/bonfire.dart';

extension DirectionExtensions on Direction {
  String getName() {
    return this.toString().replaceAll('Direction.', '');
  }
}

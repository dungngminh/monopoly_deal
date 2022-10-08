import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

class Card extends SvgComponent {
  Card({required super.svg})
      : super(
          position: Vector2(0, 0),
          size: kCardSize,
          anchor: Anchor.center,
        );

  static const kCardWidth = 1120.0;
  static const kCardHeight = 1584.0;
  static final kCardSize = Vector2(kCardWidth, kCardHeight);

  void deal() {
    print('deal');
  }
}
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class ZoomOverviewBehavior extends Component
    with ParentIsA<CameraComponent>, Subscriber<CameraEvent> {
  @override
  void onNewEvent(CameraEvent event, [Object? payload]) {
    switch (event) {
      case CameraEvent.toOverview:
        parent.add(CameraZoomEffectTo(
          MainGame2.gameMap.overviewGameVisibleSize,
          LinearEffectController(1),
        ));
        parent.viewfinder.addAll([
          MoveEffect.to(
            Vector2(0, MainGame2.gameMap.overviewGameVisibleSize.y * 0.5),
            LinearEffectController(1),
          ),
          AnchorEffect.to(Anchor.bottomCenter, LinearEffectController(1))
        ]);
        break;
      default:
    }
  }
}
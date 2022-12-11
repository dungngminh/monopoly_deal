import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class DealToPlayerBehavior extends Component
    with ParentIsA<PositionComponent>, Subscriber<CardStateMachineEvent> {
  @override
  void onNewEvent(CardStateMachineEvent event, [Object? payload]) {
    switch (event) {
      case CardStateMachineEvent.toDealRegion:
        assert(payload is CardEventDealPayload);
        parent.add(
          MoveEffect.to(
            (payload as CardEventDealPayload).playerPosition,
            LinearEffectController(0.4),
          ),
        );
        add(RemoveEffect(delay: 0.4));
        break;
      default:
    }
  }
}

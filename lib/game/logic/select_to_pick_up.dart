import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class SelectToPickUp with Publisher, Subscriber {
  SelectToPickUp({CardTracker? cardTracker})
      : _cardTracker = cardTracker ?? CardTracker();

  final CardTracker _cardTracker;

  @override
  void onNewEvent(Event event, [Object? payload]) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.tapOnMyDealRegion:
        if (_cardTracker.hasCardInAnimationState()) return;
        final cardsToPickUp = _cardTracker.cardsInMyDealRegionFromTop();
        int orderIndex = 0;
        for (var c in cardsToPickUp) {
          final inHandPosition = _cardTracker.getInHandPosition(
            index: cardsToPickUp.length - 1 - orderIndex,
            amount: cardsToPickUp.length,
          );
          notify(
            Event(CardEvent.pickUp)
              ..payload = CardPickUpPayload(
                c.cardIndex,
                orderIndex: orderIndex++,
                inHandPosition: inHandPosition,
              ),
          );
        }
        break;
      default:
    }
  }
}

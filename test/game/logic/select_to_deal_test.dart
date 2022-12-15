import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockSubscriber implements Subscriber<CardEvent> {
  int received = 0;
  final List<CardEventDealPayload> receivedPayloads = [];

  @override
  void onNewEvent(CardEvent event, [Object? payload]) {
    received++;
    receivedPayloads.add(payload as CardEventDealPayload);
  }
}

class _MockHasCardId implements HasCardId {
  _MockHasCardId({required int cardId}) : _cardId = cardId;

  final int _cardId;

  @override
  int get cardId => _cardId;
}

class _MockCardTracker extends CardTracker {
  final List<HasCardId> cards =
      List.generate(20, (index) => _MockHasCardId(cardId: index));

  @override
  List<HasCardId> cardsInDeckFromTop() {
    return cards;
  }
}

void main() {
  group('$SelectToDeal', () {
    late SelectToDeal behavior;
    late _MockCardTracker cardTracker;

    setUp(() async {
      cardTracker = _MockCardTracker();
      behavior = SelectToDeal(cardTracker: cardTracker);
    });

    test('is a ${Subscriber<CardDeckEvent>}', () {
      expect(behavior, isA<Subscriber<CardDeckEvent>>());
    });

    group('give ${CardDeckEvent.dealStartGame}, 20 cards, 2 players', () {
      test(
        "notify 10 times",
        () {
          MainGame2.gameMap = GameMap(playerPositions: [
            Vector2.all(0),
            Vector2.all(1),
          ]);
          final subscriber = _MockSubscriber();
          behavior.addSubscriber(subscriber);

          behavior.onNewEvent(CardDeckEvent.dealStartGame);

          expect(subscriber.received, 10);
        },
      );

      test(
        "notify different payloads",
        () {
          final playerPositions = [
            Vector2.all(0),
            Vector2.all(1),
          ];
          MainGame2.gameMap = GameMap(playerPositions: playerPositions);
          final subscriber = _MockSubscriber();
          behavior.addSubscriber(subscriber);

          behavior.onNewEvent(CardDeckEvent.dealStartGame);

          expect(subscriber.receivedPayloads, [
            CardEventDealPayload(0, playerPositions[0], orderIndex: 0),
            CardEventDealPayload(1, playerPositions[1], orderIndex: 1),
            CardEventDealPayload(2, playerPositions[0], orderIndex: 2),
            CardEventDealPayload(3, playerPositions[1], orderIndex: 3),
            CardEventDealPayload(4, playerPositions[0], orderIndex: 4),
            CardEventDealPayload(5, playerPositions[1], orderIndex: 5),
            CardEventDealPayload(6, playerPositions[0], orderIndex: 6),
            CardEventDealPayload(7, playerPositions[1], orderIndex: 7),
            CardEventDealPayload(8, playerPositions[0], orderIndex: 8),
            CardEventDealPayload(9, playerPositions[1], orderIndex: 9),
          ]);
        },
      );
    });
  });
}
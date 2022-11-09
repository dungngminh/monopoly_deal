import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

class PickUpTransition extends Transition {
  final Card card;

  PickUpTransition(super.stateMachine, this.card);

  @override
  State? onActivate(Command command) {
    card.addAll([
      RotateEffect.to(0, LinearEffectController(0.1)),
      MoveEffect.to(
        Vector2(
            0,
            card.game.children
                .query<CameraComponent>()
                .first
                .viewfinder
                .visibleGameSize!
                .y),
        CurvedEffectController(0.3, Curves.easeInCubic),
      )
    ]);
    return stateMachine.state(CardState.pickedUp);
  }
}

enum CardState { dealed, pickedUp }

class Card extends SpriteComponent with HasGameReference<FlameGame> {
  Card({
    required this.id,
    super.sprite,
    super.position,
    super.priority,
  }) : super(anchor: Anchor.center);

  static const kCardWidth = 280.0;
  static const kCardHeight = 395.0;
  static final kCardSize = Vector2(kCardWidth, kCardHeight);

  static const kPickUp = 0;

  final int id;
  final _stateMachines = [StateMachine()..start(CardState.dealed)];

  @override
  Future<void>? onLoad() {
    _stateMachines[0].addTransition(
      CardState.dealed,
      MapEntry(Command(kPickUp), PickUpTransition(_stateMachines[0], this)),
    );
    return super.onLoad();
  }

  void onCommand(Command command) {
    for (var m in _stateMachines) {
      m.onCommand(command);
    }
  }
}

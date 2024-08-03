import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hackathon_flutter_vienna/game_data/game_event.dart';

part 'game_data/game_state.dart';

final gameLogic = GameLogic(GameState());

class GameLogic extends ValueNotifier<GameState> {
  GameLogic(super.value);

  GameState addEvent(GameEvent event) {
    switch (event) {
      case _:
        throw UnimplementedError();
    }
  }
}

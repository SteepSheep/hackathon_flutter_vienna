import 'package:flutter/foundation.dart';
import 'package:hackathon_flutter_vienna/game_events/game_event.dart';

import 'game_data/game_state.dart';

final gameLogic = GameLogic(const GameState());

class GameLogic extends ValueNotifier<GameState> {
  GameLogic(super.value);

  GameState addEvent(GameEvent event) {
    switch (event) {
      case StartGame():
      case Join():
      case Answer():
      case SubmitArtist():
        throw UnimplementedError();
    }
  }
}

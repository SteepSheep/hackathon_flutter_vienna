import 'package:flutter/foundation.dart';
import 'package:hackathon_flutter_vienna/networking/events/network_event.dart';
import 'package:hackathon_flutter_vienna/networking/results/event_result.dart';

part 'game_state.dart';

class GameLogic extends ValueNotifier<GameState> {
  GameLogic(super.value);

  EventResult addEvent(NetworkEvent event) {
    switch (event) {
      case _:
        throw UnimplementedError();
    }
  }
}

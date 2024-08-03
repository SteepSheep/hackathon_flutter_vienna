import 'package:hackathon_flutter_vienna/networking/events/network_event.dart';
import 'package:hackathon_flutter_vienna/networking/results/event_result.dart';

final gameState = GameState();

class GameState {
  GameState();

  EventResult addEvent(NetworkEvent event) {
    switch (event) {
      case _:
        throw UnimplementedError();
    }
  }
}

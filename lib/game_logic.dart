import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:hackathon_flutter_vienna/game_events/game_event.dart';

import 'game_data/game_state.dart';

final gameLogic = GameLogic(const GameState());

class GameLogic extends ValueNotifier<GameState> {
  GameClient? client;

  GameLogic(super.value);

  Future<GameState> addEvent(GameEvent event) async {
    if (client case final c?) {
      return await c.sendEvent(event);
    } else {
      switch (event) {
        case StartGame():
        case Join():
        case Answer():
        case SubmitArtist():
          throw UnimplementedError();
      }
    }
  }
}

class GameClient {
  GameClient({required this.host});

  final String host;

  final _client = http.Client();

  Future<GameState> sendEvent(GameEvent event) async {
    await _client.post(Uri(scheme: 'http', host: host));
    throw UnimplementedError();
  }
}

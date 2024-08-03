import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hackathon_flutter_vienna/game_events/game_event.dart';
import 'package:http/http.dart' as http;

import 'game_data/game_state.dart';

final gameLogic = GameLogic(const GameState());

class GameLogic extends ValueNotifier<GameState> {
  GameClient? client;

  GameLogic(super.value);

  Future<GameState> addEvent(GameEvent event) async {
    if (client case final c?) {
      final state = await c.sendEvent(event);
      if (state != null) {
        value = state;
        return state;
      } else {
        return value;
      }
    } else {
      GameState newState;
      switch (event) {
        case StartGame():
          newState = value.copyWith(phase: GamePhase.playing);
        case Join(name: final name):
          newState = value.copyWith(players: List.of(value.players)..add(name));
        case Answer(name: final name, answer: final answer):
          newState = value.copyWith(
              answers: Map.of(value.answers)..addAll({name: answer}),
              timestamps: Map.of(value.timestamps)
                ..addAll({name: DateTime.now().millisecondsSinceEpoch}));
        case SubmitArtist(name: final name, artist: final artist):
          newState = value.copyWith(questions: [const QuestionData.fake()]);
      }

      value = newState;
      return value;
    }
  }
}

class GameClient {
  GameClient({required this.host});

  final String host;

  final _client = http.Client();

  Future<GameState?> sendEvent(GameEvent event, {int retries = 3}) async {
    final response = await _client.post(Uri(scheme: 'http', host: host),
        body: event.toJson());
    if (response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return GameState.fromJson(data);
    } else if (response.statusCode < 500) {
      return null;
    } else if (retries > 0) {
      return sendEvent(event, retries: retries - 1);
    } else {
      return null;
    }
  }
}

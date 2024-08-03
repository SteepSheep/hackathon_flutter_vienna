import 'package:flutter/foundation.dart';

enum EventType {
  join,
  sendArtist,
  start,
  sendAnswer,
}

@immutable
sealed class GameEvent {
  const GameEvent({required this.type});

  final EventType type;

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case {'type': 'start'}:
        return const StartGame();
      case _:
        throw ArgumentError('Not a valid $GameEvent: $json');
    }
  }
}

class Join extends GameEvent {
  const Join(this.name) : super(type: EventType.join);

  final String name;
}

class StartGame extends GameEvent {
  const StartGame() : super(type: EventType.start);
}

class SubmitArtist extends GameEvent {
  const SubmitArtist(this.artist) : super(type: EventType.sendArtist);

  final String artist;
}
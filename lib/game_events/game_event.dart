import 'package:flutter/foundation.dart';

enum EventType {
  get,
  sendArtist,
  start,
  sendAnswer,
}

@immutable
sealed class GameEvent {
  const GameEvent({
    required this.type,
    required this.name,
  });

  final EventType type;
  final String name;

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case {
          'type': EventType.get,
          'name': _,
        }:
        return const GetData();
      case {
          'type': EventType.sendArtist,
          'name': String name,
          'artist': String artist,
        }:
        return SubmitArtist(name: name, artist: artist);
      case {
          'type': EventType.start,
          'name': String name,
        }:
        return StartGame(name: name);
      case {
          'type': EventType.sendAnswer,
          'name': String name,
          'answer': int answer,
        }:
        return Answer(name: name, answer: answer);
      case _:
        throw ArgumentError('Not a valid $GameEvent: $json');
    }
  }

  @mustCallSuper
  Map<String, dynamic> toJson() => {
        'type': type.index,
        'name': name,
      };
}

class GetData extends GameEvent {
  const GetData() : super(type: EventType.get, name: '');
}

class StartGame extends GameEvent {
  const StartGame({required super.name}) : super(type: EventType.start);
}

class SubmitArtist extends GameEvent {
  const SubmitArtist({
    required super.name,
    required this.artist,
  }) : super(type: EventType.sendArtist);

  final String artist;

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll({'artist': artist});
}

class Answer extends GameEvent {
  const Answer({
    required super.name,
    required this.answer,
  }) : super(type: EventType.sendAnswer);

  final int answer;

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll({'answer': answer});
}

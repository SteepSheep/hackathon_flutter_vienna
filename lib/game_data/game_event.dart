sealed class GameEvent {
  const GameEvent();

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case _:
        throw ArgumentError('Not a valid $GameEvent: $json');
    }
  }
}

class StartGame extends GameEvent {
  const StartGame();
}

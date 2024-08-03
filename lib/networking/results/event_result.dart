sealed class EventResult {
  const EventResult();

  factory EventResult.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case _:
        throw ArgumentError('Not a valid $EventResult: $json');
    }
  }
}

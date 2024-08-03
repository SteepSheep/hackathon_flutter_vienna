sealed class NetworkEvent {
  const NetworkEvent();

  factory NetworkEvent.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case _:
        throw ArgumentError('Not a valid $NetworkEvent: $json');
    }
  }
}

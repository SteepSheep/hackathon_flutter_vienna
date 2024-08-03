import 'package:hackathon_flutter_vienna/networking/events/network_event.dart';
import 'package:hackathon_flutter_vienna/networking/results/event_result.dart';

abstract class EventHandler {
  static EventResult handle(NetworkEvent event) {
    switch (event) {
      case _:
        throw UnimplementedError();
    }
  }
}

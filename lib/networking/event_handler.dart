import 'package:hackathon_flutter_vienna/networking/event_result.dart';
import 'package:hackathon_flutter_vienna/networking/network_event.dart';

abstract class EventHandler {
  static EventResult handle(NetworkEvent event) {
    switch (event) {
      case _:
        throw UnimplementedError();
    }
  }
}

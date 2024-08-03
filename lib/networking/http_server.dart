import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hackathon_flutter_vienna/game_events/game_event.dart';
import 'package:hackathon_flutter_vienna/game_logic.dart';

Future<void> startServer() async {
  final httpServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Started server on ${httpServer.address}, port ${httpServer.port}');

  await for (final request in httpServer) {
    final responseBytes = Uint8List(request.contentLength);
    int idx = 0;
    await request.forEach((bytes) {
      responseBytes.setAll(idx, bytes);
      idx += bytes.length;
    });

    try {
      final jsonString = utf8.decode(responseBytes);
      print('Received json: $jsonString');
      final decoded = json.decode(jsonString, reviver: _eventTypeReviver);
      final event = GameEvent.fromJson(decoded);

      final newState = gameLogic.addEvent(event);
      request.response.write(json.encode(newState));
      await request.response.flush();
    } finally {
      await request.response.close();
    }
  }
}

Object? _eventTypeReviver(Object? key, Object? value) {
  if (key == 'type') {
    assert(value is int, 'Expected type to be int');
    return EventType.values[value as int];
  }
  return value;
}

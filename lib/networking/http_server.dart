import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hackathon_flutter_vienna/networking/event_handler.dart';
import 'package:hackathon_flutter_vienna/networking/events/network_event.dart';

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
      final decoded = json.decode(jsonString);
      final event = NetworkEvent.fromJson(decoded);

      final eventResult = EventHandler.handle(event);
      request.response.write(json.encode(eventResult));
      await request.response.flush();
    } finally {
      await request.response.close();
    }
  }
}

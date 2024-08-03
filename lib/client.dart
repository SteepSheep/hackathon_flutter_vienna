import 'dart:async';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_flutter_vienna/game_data/game_state.dart';
import 'package:hackathon_flutter_vienna/game_logic.dart';
import 'package:hackathon_flutter_vienna/server.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Scaffold(
    body: ValueListenableBuilder(
      valueListenable: gameLogic,
      builder: (context, state, _) => GameClientPage(gameState: state),
    ),
  ));
}

class GameClientPage extends StatefulWidget {
  const GameClientPage({super.key, required this.gameState});

  final GameState gameState;

  @override
  State<StatefulWidget> createState() => GameClientPageState();
}

class GameClientPageState extends State<GameClientPage> {
  final _discovery = BonsoirDiscovery(type: gameService.type);
  StreamSubscription<BonsoirDiscoveryEvent>? _discoverySub;
  ResolvedBonsoirService? _service;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  void _startDiscovery() async {
    await _discovery.ready;
    _discoverySub?.cancel();
    _discoverySub = _discovery.eventStream!.listen((event) {
      switch (event.type) {
        case BonsoirDiscoveryEventType.discoveryServiceFound:
          if (event.service case final service?) {
            service.resolve(_discovery.serviceResolver);
          } else {
            debugPrint('${event.type} with missing service!!!');
          }
        case BonsoirDiscoveryEventType.discoveryServiceResolved:
          if (event.service case final ResolvedBonsoirService service?) {
            _service = service;
            gameLogic.client = GameClient(host: service.host!);
          } else {
            debugPrint('${event.type} with missing service!!!');
          }
        case BonsoirDiscoveryEventType.discoveryStarted:
        case BonsoirDiscoveryEventType.discoveryStopped:
        case BonsoirDiscoveryEventType.discoveryServiceLost:
        case BonsoirDiscoveryEventType.discoveryServiceResolveFailed:
        case BonsoirDiscoveryEventType.unknown:
          debugPrint('Discovery: ${event.type}');
      }
      setState(() {});
    });
    await _discovery.start();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}

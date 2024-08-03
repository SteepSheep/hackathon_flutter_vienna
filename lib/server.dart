import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_flutter_vienna/game_logic.dart';
import 'package:hackathon_flutter_vienna/networking/events/network_event.dart';

const gameName = 'THE game!';

final gameService = BonsoirService(
  name: '$gameName Service',
  type: '_thegame._tcp',
  port: 80,
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Scaffold(
    body: ValueListenableBuilder(
      valueListenable: gameLogic,
      builder: (context, state, _) => GameServerPage(gameState: state),
    ),
  ));
}

class GameServerPage extends StatefulWidget {
  const GameServerPage({super.key, required this.gameState});

  final GameState gameState;

  @override
  State<StatefulWidget> createState() => GameServerPageState();
}

class GameServerPageState extends State<GameServerPage> {
  BonsoirBroadcast? _broadcast;

  @override
  void didUpdateWidget(covariant GameServerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gameState.started != widget.gameState.started) {
      if (widget.gameState.started) {
        _stopBroadcasting();
      } else {
        _startBroadcasting();
      }
    }
  }

  void _startBroadcasting() async {
    final b = _broadcast = BonsoirBroadcast(service: gameService);
    await b.ready;
    await b.start();
    setState(() {});
  }

  void _stopBroadcasting() async {
    if (_broadcast case final b?) {
      await b.stop();
      setState(() {
        _broadcast = null;
      });
    }
  }

  void _startGame() {
    gameLogic.addEvent(const StartGame());
  }

  @override
  Widget build(BuildContext context) {
    const vspace = SizedBox(height: 30);

    final gameState = widget.gameState;
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);

    if (gameState.started) {
      return SizedBox();
    }

    return Column(
      children: [
        Text(
          'Waiting for players...',
          style: textTheme.displayMedium,
        ),
        vspace,
        for (final player in gameState.players)
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(player),
          ),
        vspace,
        if (gameState.players.length > 1)
          ElevatedButton(
            onPressed: _startGame,
            child: Text('Start Game'),
          ),
      ],
    );
  }
}

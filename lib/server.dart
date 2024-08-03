import 'package:audioplayers/audioplayers.dart';
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
  late final player = AudioPlayer();

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
    if (oldWidget.gameState.song != widget.gameState.song) {
      final song = widget.gameState.song;
      if (song != null) {
        _playSong(song);
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

  void _playSong(Uri uri) {
    player.play(UrlSource('uri'));
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '';
    return '${d.inSeconds} sec';
  }

  bool get _started;
  List<String> get _players;
  Uri? get _song;
  Map<String, int> get _playerAnswers;
  Map<String, Duration> get _playerTimes;
  String? get _winner;
  int get _correctAnswer;

  @override
  Widget build(BuildContext context) {
    final gameState = widget.gameState;
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);

    const vspace = SizedBox(height: 30);
    final titleStyle = textTheme.displayMedium;

    if (_started) {
      if (_song == null) {
        return Column(
          children: [
            Text('Submit an artist!'),
          ],
        );
      }
      if (_winner != null) {
        return Column(
          children: [
            Text(
              '🎆 We have a winner!',
              style: titleStyle,
            ),
            for (final player in _players)
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: Text(
                  player,
                  style: TextStyle(
                    fontWeight:
                        _winner == player ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                tileColor: _winner == player ? Colors.amber : null,
                trailing: _playerAnswers[player] == _correctAnswer
                    ? Text(_formatDuration(_playerTimes[player]))
                    : null,
              ),
          ],
        );
      }
      return Column(
        children: [
          Text(
            '🎵 What\'s the song?',
            style: titleStyle,
          ),
          vspace,
          for (final player in _playerAnswers.keys)
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(player),
              trailing: const Icon(
                Icons.check,
                color: Colors.green,
              ),
            ),
        ],
      );
    }

    return Column(
      children: [
        Text(
          'Waiting for players...',
          style: titleStyle,
        ),
        vspace,
        for (final player in _players)
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

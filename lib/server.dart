import 'package:audioplayers/audioplayers.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_flutter_vienna/game_data/game_state.dart';
import 'package:hackathon_flutter_vienna/game_events/game_event.dart';
import 'package:hackathon_flutter_vienna/game_logic.dart';
import 'package:hackathon_flutter_vienna/networking/http_server.dart';
import 'package:hackathon_flutter_vienna/yt_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

const gameName = 'THE game!';

final gameService = BonsoirService(
  name: '$gameName Service',
  type: '_thegame._tcp',
  port: 80,
);

void main() {
  startServer();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: ValueListenableBuilder(
              valueListenable: gameLogic,
              builder: (context, state, _) => GameServerPage(gameState: state),
            ),
          ),
        ),
      ),
    ),
  );
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
  void initState() {
    super.initState();
    _startBroadcasting();
  }

  @override
  void didUpdateWidget(covariant GameServerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gameState.phase != widget.gameState.phase) {
      if (widget.gameState.phase != GamePhase.lobby) {
        _stopBroadcasting();
      } else {
        _startBroadcasting();
      }
    }

    print(oldWidget.gameState.toJson());
    print(widget.gameState.toJson());
    if (widget.gameState.questions.isNotEmpty) {
      final song = widget
          .gameState.questions[widget.gameState.currentQuestionIndex].songUrl;
      if (oldWidget.gameState.questions.isEmpty ||
          oldWidget.gameState.currentQuestionIndex !=
              widget.gameState.currentQuestionIndex) {
        _playSong(
            song,
            widget.gameState.questions[widget.gameState.currentQuestionIndex]
                .songPositionSeconds);
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
    gameLogic.addEvent(const StartGame(name: ''));
  }

  void _playSong(String uri, int positionSeconds) async {
    final yt = YoutubeExplode();
    const videoId = 'W8tbQgXyn1c';
    final manifest = await yt.videos.streamsClient.getManifest(videoId);
    final fakeUri = manifest.audioOnly.first.url.toString();
    print(fakeUri);
    await player.seek(Duration(seconds: positionSeconds));
    await player.play(UrlSource(fakeUri));
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '';
    return '${d.inSeconds} sec';
  }

  bool get _started => widget.gameState.phase != GamePhase.lobby;
  List<String> get _players => widget.gameState.players;
  String? get _song => widget.gameState.questions.isEmpty
      ? null
      : widget
          .gameState.questions[widget.gameState.currentQuestionIndex].songUrl;
  Map<String, int> get _playerAnswers => widget.gameState.answers;
  Map<String, Duration> get _playerTimes => widget.gameState.timestamps
      .map((key, value) => MapEntry(key, Duration(seconds: value.round())));
  String? get _winner => widget.gameState.winner;
  int get _correctAnswer => widget.gameState.questions.isEmpty
      ? -1
      : widget.gameState.questions[widget.gameState.currentQuestionIndex]
          .correctAnswer;

  @override
  Widget build(BuildContext context) {
    final gameState = widget.gameState;
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);

    const vspace = SizedBox(height: 30);
    final titleStyle = textTheme.displayMedium;

    if (_started) {
      if (_song == null) {
        return const Column(
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
        if (gameState.players.isNotEmpty)
          ElevatedButton(
            onPressed: _startGame,
            child: const Text('Start Game'),
          ),
      ],
    );
  }
}

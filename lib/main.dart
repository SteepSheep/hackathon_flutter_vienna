import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

const gameName = 'THE game!';
final gameService = BonsoirService(
  name: '$gameName Service',
  type: '_thegame._tcp',
  port: 80,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BonsoirPage(),
    );
  }
}

class BonsoirPage extends StatefulWidget {
  const BonsoirPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return BonsoirPageState();
  }
}

class BonsoirPageState extends State<BonsoirPage> {
  BonsoirBroadcast? _broadcast;
  final _discovery = BonsoirDiscovery(type: gameService.type);
  StreamSubscription<BonsoirDiscoveryEvent>? _discoverySub;

  // Maps service host to service info
  final _peers = <String, ResolvedBonsoirService>{};

  @override
  void initState() {
    super.initState();
    _startDiscovery();
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
      _broadcast = null;
      setState(() {});
    }
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
            if (service.host case final host?) {
              _peers[host] = service;
            } else {
              debugPrint('Resolved service with missing host');
            }
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

  void checkYt() async {
    final player = AudioPlayer();
    final yt = YoutubeExplode();
    var video = await yt.videos.get(
        'https://www.youtube.com/watch?v=4NRXx6U8ABQ&pp=ygUKdGhlIHdlZWtuZA%3D%3D');

    final videoId = video.id.value;
    setState(() {});
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var audioUrl = manifest.audioOnly.first.url;
    var audioUrlString = audioUrl.toString();
    player.play(UrlSource(audioUrlString));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (_broadcast == null)
            ElevatedButton(
              onPressed: _startBroadcasting,
              child: const Text('Start broadcasting'),
            )
          else
            ElevatedButton(
              onPressed: _stopBroadcasting,
              child: const Text('Stop broadcasting'),
            ),
          if (_discoverySub != null) const Text('Discovering...'),
          if (_peers.isEmpty)
            const Text('No peers found')
          else
            for (final peer in _peers.entries) Text(peer.key)
        ],
      ),
    );
  }
}

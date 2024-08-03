import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => checkYt(),
        tooltip: 'Play',
        child: const Icon(Icons.add),
      ),
    );
  }

  void checkYt() async {
    final player = AudioPlayer();
    final yt = YoutubeExplode();
    var video = await yt.videos.get('https://www.youtube.com/watch?v=4NRXx6U8ABQ&pp=ygUKdGhlIHdlZWtuZA%3D%3D');

    final videoId = video.id.value;
    setState(() {});
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var audioUrl = manifest.audioOnly.first.url;
    var audioUrlString = audioUrl.toString();
    player.play(UrlSource(audioUrlString));

    /* var yt = YoutubeExplode();
  var manifest = await yt.videos.streamsClient.getManifest(videoId);

  // Get the audio-only stream URL
  var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
  var audioStreamUrl = audioStreamInfo.url.toString();

  yt.close(); */
  }
}

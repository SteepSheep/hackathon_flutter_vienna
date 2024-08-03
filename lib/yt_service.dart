import 'package:audioplayers/audioplayers.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void checkYt(String artistName) async {
  final player = AudioPlayer();
  final yt = YoutubeExplode();

  var videoList = await yt.search(artistName);
  var videoToGuess = videoList.first;
  final videoDuration = videoToGuess.duration;
  final videoId = videoToGuess.id.value;
  var manifest = await yt.videos.streamsClient.getManifest(videoId);
  var audioUrl = manifest.audioOnly.first.url;
  var audioUrlString = audioUrl.toString();

  await player.seek(videoDuration! ~/ 2);
  await player.play(UrlSource(audioUrlString));
  await Future.delayed(const Duration(seconds: 3));
  await player.pause();
}

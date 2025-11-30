import 'package:audioplayers/audioplayers.dart';

class MusicService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Future<void> play() async {
    await _audioPlayer.play(UrlSource(
      'https://ia800504.us.archive.org/33/items/ErikSatieGymnopedieNo1/ErikSatieGymnopedieNo1.mp3'
    ));
    _isPlaying = true;
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
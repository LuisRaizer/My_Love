import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  
  static Future<void> playPopSound() async {
    try {
      ByteData data = await rootBundle.load('lib/assets/pop.wav');
      Uint8List bytes = data.buffer.asUint8List();
      await _player.play(BytesSource(bytes));
    } catch (e) {
      print('Erro ao reproduzir som: $e');
    }
  }
  
  static void dispose() {
    _player.dispose();
  }
}
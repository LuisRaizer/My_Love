import 'dart:math';
import '../models/balloon_model.dart';

class BalloonManager {
  final Random _random = Random();
  static const double _balloonWidth = 180.0;

  final List<String> _normalMessages = [
    'Amo ela',
    'Será que ela vai gostar disso?',
    'Tomara que ela lembre sempre que usar',
    'Eu tentei fazer o que pude',
    'Ta tudo registrado',
    'Era só um boa noite ao vivo que eu dormia mansinho',
    'sempre querendo ela',
    'que saudade, meu deus',
    'se vc clicar no balão, ele estoura',
  ];

  final List<String> _loveMessages = [
    'R + G = ❤️‍🩹',
    'Razi ama delha',
    'Ela odeia homens, mas me ama KKKK',
  ];

  Balloon createRandomBalloon({double maxLeft = 250, double maxTop = 150}) {
    String type;
    final rand = _random.nextDouble();

    if (rand < 0.05) {
      type = 'surprise';
    } else if (rand < 0.15) {
      type = 'love';
    } else if (rand < 0.25) {
      type = 'secret';
    } else {
      type = 'normal';
    }

    String message;
    switch (type) {
      case 'love':
        message = _loveMessages[_random.nextInt(_loveMessages.length)];
        break;
      case 'surprise':
        message = '🎉 Balão especial!';
        break;
      default:
        message = _normalMessages[_random.nextInt(_normalMessages.length)];
    }

    int requiredTaps = 1;
    if (type == 'love') requiredTaps = 2;
    if (type == 'secret') requiredTaps = 3;

    double left = _random.nextDouble() * (maxLeft - _balloonWidth) + 20;
    double top = _random.nextDouble() * maxTop;

    return Balloon(
      id: '${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(1000)}',
      message: message,
      type: type,
      left: left,
      top: top,
      requiredTaps: requiredTaps,
    );
  }
}

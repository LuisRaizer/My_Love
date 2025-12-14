import 'dart:math';
import 'package:app/utils/personal_content.dart';
import 'package:app/models/balloon_model.dart';

class BalloonManager {
  final Random _random = Random();
  static const double _balloonWidth = 250.0;

  final List<String> _normalMessages = PersonalConfig.normalBalloonMessages;
  final List<String> _loveMessages = PersonalConfig.loveBalloonMessages;

  Balloon createRandomBalloon({double maxLeft = 250, double maxTop = 150}) {
    String type;
    final rand = _random.nextDouble();

    if (rand < 0.05) {
      type = 'surprise';
    } else if (rand < 0.30) {
      type = 'love';
    } else if (rand < 0.35) {
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

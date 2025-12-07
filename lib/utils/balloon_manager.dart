import 'dart:math';
import '../models/balloon_model.dart';

class BalloonManager {
  final Random _random = Random();
  static const double _balloonWidth = 250.0;

  final List<String> _normalMessages = [
    'Amo ela',
    'Será que ela vai gostar disso?',
    'Tomara que ela lembre sempre de usar',
    'Eu tentei fazer o que pude',
    'Ta tudo registrado no github',
    'sempre querendo ela',
    'que saudade, meu deus',
    'se vc clicar no balão, ele estoura',
    'atualmente são 02 da manhã KKKK',
    'top 10 apps pode falar',
    'top 1 apps po, slk',
    'pensado aqui, e se eu fizer um app pra ela?',
    'isso é mais divertido do que parece',
    'vou encher a tela de balões',
    'isso é só entre nós',
    'tudo por ela',
    'ela não sabe o poder que tem',
    'cada parte dela é perfeita',
    'ela anda, eu corro atrás',
    'ela é o meu começo',
  ];

  final List<String> _loveMessages = [
    'R + G = ❤️‍🩹',
    'Razi ama delha',
    'Ela odeia homens, mas me ama KKKK',
    'Era só um boa noite ao vivo que eu dormia mansinho',
    'amo fazer surpresas para ela',
    'ela é minha princesa',
    'essas coxona vão me matar um dia, graças a Deus',
    'minha vida sem ela seria 100x mais chata, slk',
    'deve ser tão triste, dançar nos braços de quem não te ama',
    'não existem balões suficientes pra tanto amor',
    'meu sonho é acordar com ela',
    'dormir agarradinho com ela ia ser insano ta',
    'perdido nela',
    'eu sou o fã número 1 dessa mulher',
  ];

  Balloon createRandomBalloon({double maxLeft = 250, double maxTop = 150}) {
    String type;
    final rand = _random.nextDouble();

    if (rand < 0.05) {
      type = 'surprise';
    } else if (rand < 0.25) {
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

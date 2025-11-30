import 'package:confetti/confetti.dart';

class ConfettiService {
  late ConfettiController _confettiController;

  ConfettiService() {
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  void showConfetti() {
    _confettiController.play();
  }

  void showMiniConfetti() {
    _confettiController.play();
  }

  ConfettiController get controller => _confettiController;

  void dispose() {
    _confettiController.dispose();
  }
}
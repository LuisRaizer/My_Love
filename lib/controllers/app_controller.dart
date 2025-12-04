import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:app/models/app_state.dart';

class AppController extends ChangeNotifier {
  final AppState _state = AppState();
  final ConfettiController confettiController = ConfettiController(duration: Duration(seconds: 2));

  AppState get state => _state;

  void initialize() {}


  void startApp() {
    _state.hideIntro();
    _state.toggleMusic();
    confettiController.play();
  }

  void incrementLove() {
    _state.incrementLove();
    confettiController.play();
  }

  void openGift() {
    _state.openGift();
    confettiController.play();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }
}
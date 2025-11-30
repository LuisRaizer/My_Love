import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:app/models/app_state.dart';
import 'package:app/services/music_service.dart';

class AppController extends ChangeNotifier {
  final AppState _state = AppState();
  final MusicService _musicService = MusicService();
  final ConfettiController confettiController = ConfettiController(duration: Duration(seconds: 2));

  AppState get state => _state;

  void initialize() {}

  void toggleMusic() async {
    if (_state.isMusicPlaying) {
      await _musicService.pause();
    } else {
      await _musicService.play();
    }
    _state.toggleMusic();
  }

  void startApp() {
    _state.hideIntro();
    _musicService.play();
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

  void makeAWish() {
    // Efeito de estrela cadente pode ser implementado aqui
  }

  @override
  void dispose() {
    _musicService.dispose();
    confettiController.dispose();
    super.dispose();
  }
}
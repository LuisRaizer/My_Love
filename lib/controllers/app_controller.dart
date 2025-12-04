import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/models/app_state.dart';
import 'package:app/services/music_service.dart';

class AppController extends ChangeNotifier {
  final AppState _state = AppState();
  final MusicService _musicService = MusicService();
  final ConfettiController confettiController = ConfettiController(duration: Duration(seconds: 2));

  AppState get state => _state;

  Future<void> initialize() async {
    await _checkSkipIntroPreference();
  }

  Future<void> _checkSkipIntroPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shouldSkipIntro = prefs.getBool('skipIntro') ?? false;
      
      if (shouldSkipIntro) {
        _state.hideIntro();
        await _musicService.play();
        _state.toggleMusic();
      }
    } catch (e) {
      print('Erro ao verificar preferência de intro: $e');
    }
  }

  Future<void> _saveSkipIntroPreference(bool skipIntro) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('skipIntro', skipIntro);
    } catch (e) {
      print('Erro ao salvar preferência de intro: $e');
    }
  }

  void toggleMusic() async {
    if (_state.isMusicPlaying) {
      await _musicService.pause();
    } else {
      await _musicService.play();
    }
    _state.toggleMusic();
  }

  

  void startApp({bool skipIntroNextTime = false}) async {
    if (skipIntroNextTime) {
      await _saveSkipIntroPreference(true);
    }
    
    _state.hideIntro();
    
    await _musicService.play();
    _state.toggleMusic();
    confettiController.play();
  }
  Future<void> resetIntroPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('skipIntro');
      _state.showIntro = true;
      notifyListeners();
    } catch (e) {
      print('Erro ao resetar preferência de intro: $e');
    }
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
    _musicService.dispose();
    confettiController.dispose();
    super.dispose();
  }
}
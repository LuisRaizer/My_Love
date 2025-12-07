import 'dart:async';
import 'package:app/utils/balloon_manager.dart';
import 'package:flutter/material.dart';
import 'package:app/models/balloon_model.dart';
import 'package:app/services/store_balloon_service.dart';

class BalloonController extends ChangeNotifier {
  final BalloonManager _manager = BalloonManager();
  Timer? _spawnTimer;
  final int _maxBalloons = 12;
  final Duration _spawnInterval = const Duration(seconds: 3);
  final Duration _balloonLifetime = const Duration(seconds: 25);

  final List<Balloon> _activeBalloons = [];
  List<Balloon> get activeBalloons => List.unmodifiable(_activeBalloons);

  int _totalPopped = 0;
  int _highestCombo = 0;
  Timer? _comboTimer;
  final Map<String, int> _poppedByType = {};

  int get totalPopped => _totalPopped;
  int get highestCombo => _highestCombo;
  Map<String, int> get poppedByType => Map.unmodifiable(_poppedByType);

  void Function(int milestone)? onReachMilestone;

  BalloonController() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    _totalPopped = await StorageService.getTotalPopped();
    print('BalloonController: Carregados $_totalPopped balões estourados do storage');
    notifyListeners();
  }

  void startSpawning() {
    if (_spawnTimer != null) return;
    _spawnTimer = Timer.periodic(_spawnInterval, (timer) {
      print('BalloonController: Timer tick. Balões ativos: ${_activeBalloons.length}');
      if (_activeBalloons.length < _maxBalloons) {
        _spawnBalloon();
      }
    });
  }

  void stopSpawning() {
    print('BalloonController: Parando spawn');
    _spawnTimer?.cancel();
    _spawnTimer = null;
  }

  void _spawnBalloon() {
    final balloon = _manager.createRandomBalloon(maxTop: 100);
    
    print('BalloonController: Criando balão ${balloon.id} em (${balloon.left}, ${balloon.top})');
    
    balloon.startAutoRemoveTimer(_balloonLifetime, () {
      removeBalloon(balloon.id, popped: false);
    });

    _activeBalloons.add(balloon);
    print('BalloonController: Balão adicionado. Total: ${_activeBalloons.length}');
    notifyListeners();
  }

  void removeBalloon(String balloonId, {bool popped = true}) {
    final index = _activeBalloons.indexWhere((b) => b.id == balloonId);
    if (index != -1) {
      final balloon = _activeBalloons[index];
      balloon.cancelTimer();
      _activeBalloons.removeAt(index);

      if (popped) {
        _recordPop(balloon);
      }

      print('BalloonController: Balão removido. Restantes: ${_activeBalloons.length}');
      notifyListeners();
    }
  }

  void _recordPop(Balloon balloon) async {
    _totalPopped++;
    
    await StorageService.saveTotalPopped(_totalPopped);
    
    if (_totalPopped % 20 == 0) {
      final lastMilestoneShown = await StorageService.getLastMilestoneShown();
      
      if (_totalPopped > lastMilestoneShown) {
        await StorageService.saveLastMilestoneShown(_totalPopped);
        if (onReachMilestone != null) {
          onReachMilestone!(_totalPopped);
        }
      }
    }
    
    _poppedByType.update(
      balloon.type,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
    notifyListeners();
  }

  void incrementBalloonTaps(String balloonId) {
    final index = _activeBalloons.indexWhere((b) => b.id == balloonId);
    if (index != -1) {
      _activeBalloons[index].incrementTaps();
      notifyListeners();
    }
  }

  void addBalloon() {
    print('BalloonController: Adicionando balão manualmente');
    _spawnBalloon();
  }

  void removeAllBalloons() {
    for (var balloon in _activeBalloons) {
      balloon.cancelTimer();
    }
    _activeBalloons.clear();
    notifyListeners();
  }

  void resetStats() async {
    _totalPopped = 0;
    _highestCombo = 0;
    _poppedByType.clear();
    await StorageService.resetAll();
    notifyListeners();
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _comboTimer?.cancel();
    for (var balloon in _activeBalloons) {
      balloon.cancelTimer();
    }
    super.dispose();
  }
}
import 'dart:async';
import 'dart:ui';

class Balloon {
  final String id;
  final String message;
  final String type;
  final double left;
  final double top;
  final int requiredTaps;
  int currentTaps;
  Timer? autoRemoveTimer;

  Balloon({
    required this.id,
    required this.message,
    required this.type,
    required this.left,
    required this.top,
    this.requiredTaps = 1,
    this.currentTaps = 0,
  });

  bool get isReadyToPop => currentTaps >= requiredTaps;
  
  void incrementTaps() {
    currentTaps++;
  }
  
  void startAutoRemoveTimer(Duration duration, VoidCallback onTimerComplete) {
    // CORREÇÃO: Cancelar timer existente primeiro
    autoRemoveTimer?.cancel();
    autoRemoveTimer = Timer(duration, onTimerComplete);
  }
  
  void cancelTimer() {
    autoRemoveTimer?.cancel();
    autoRemoveTimer = null;
  }
}
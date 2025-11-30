import 'dart:async';
import 'package:flutter/material.dart';

class TimerController extends ChangeNotifier {
  final DateTime _firstKissDate = DateTime(2025, 5, 15);
  Duration _timeTogether = Duration.zero;
  Timer? _timer;

  Duration get timeTogether => _timeTogether;

  TimerController() {
    _startTimer();
  }

  void _startTimer() {
    _updateTime();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    _timeTogether = DateTime.now().difference(_firstKissDate);
    notifyListeners();
  }

  String getFormattedTime() {
    int months = (_timeTogether.inDays % 365) ~/ 30;
    int days = _timeTogether.inDays % 30;
    int hours = _timeTogether.inHours % 24;

    return '$months meses, $days dias e $hours horas';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
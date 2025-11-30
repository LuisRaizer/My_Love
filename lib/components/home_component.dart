import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/timer_controller.dart';

class HomeComponent extends StatefulWidget {
  final AppController appController;
  final TimerController timerController;

  const HomeComponent({
    super.key,
    required this.appController,
    required this.timerController,
  });

  @override
  State<HomeComponent> createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  final List<Map<String, dynamic>> _balloons = [];
  final List<String> _messages = [
    'Amo ela',
    'Era para ser o snoopy pensando',
    'Será que ela vai gostar disso?',
    'Tomara que ela lembre sempre que usar',
    'R + G = ❤️‍🩹',
    'Razi ama delha',
    'Eu tentei fazer o que pude',
    'Ta tudo registrado',
    'Ela odeia homens, mas me ama KKKK',
    'Amo muito ela',
  ];

  @override
  void initState() {
    super.initState();
    _startBalloons();
  }

  void _startBalloons() {
    Future.delayed(const Duration(seconds: 3), _addBalloon);
    
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) _addBalloon();
    });
  }

  void _addBalloon() {
    if (!mounted) return;
    
    final random = Random();
    setState(() {
      _balloons.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'message': _messages[random.nextInt(_messages.length)],
        'left': random.nextDouble() * 160 + 20,
        'opacity': 1.0,
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _balloons.isNotEmpty) {
        setState(() {
          _balloons.removeAt(0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 100),
              _buildSnoopyWithBalloons(),
              _buildTitle(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSnoopyWithBalloons() {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => widget.appController.incrementLove(),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: Image.asset(
                      'lib/assets/snoopy.gif',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          ..._balloons.map(_buildBalloon),
        ],
      ),
    );
  }

  Widget _buildBalloon(Map<String, dynamic> balloon) {
    return Positioned(
      left: balloon['left'] as double,
      top: 30,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),
        opacity: balloon['opacity'] as double,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.greenAccent, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            balloon['message'] as String,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Bem-Vinda meu amor!',
      style: TextStyle(
        fontFamily: 'FredokaOne',
        fontSize: 32,
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}
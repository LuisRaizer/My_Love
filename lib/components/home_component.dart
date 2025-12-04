import 'dart:async';
import 'dart:math';

import 'package:app/widgets/balloon_widget.dart';
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
  final Random _random = Random();
  
  final List<String> _messages = [
    'Amo ela',
    'Será que ela vai gostar disso?',
    'Tomara que ela lembre sempre que usar',
    'R + G = ❤️‍🩹',
    'Razi ama delha',
    'Eu tentei fazer o que pude',
    'Ta tudo registrado',
    'Ela odeia homens, mas me ama KKKK',
    'Era só um boa noite ao vivo que eu dormia mansinho',
    'sempre querendo ela',
    'que saudade, meu deus',
    'se vc clicar no balão, ele desaparece',
  ];

  @override
  void initState() {
    super.initState();
    _startBalloons();
  }

  void _startBalloons() {    
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _balloons.length < 4) {
        _addBalloon();
      }
    });
  }

  void _addBalloon() {
    if (!mounted) return;
    
    setState(() {
      _balloons.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'message': _messages[_random.nextInt(_messages.length)],
        'left': _random.nextDouble() * 200 + 30,
        'top': _random.nextDouble() * 50 + 20,
        'opacity': 1.0,
      });
    });

    Future.delayed(const Duration(seconds: 12), () {
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
          
          ..._balloons.map((balloon) {
            return BalloonWidget(
              message: balloon['message'] as String,
              left: balloon['left'] as double,
              top: balloon['top'] as double,
              opacity: balloon['opacity'] as double,
              onTap: () {
                setState(() {
                  _balloons.remove(balloon);
                });
              },
            );
          }),
        ],
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
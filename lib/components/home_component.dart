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
  Timer? _balloonTimer;
  
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
    'se vc clicar no balão, ele estoura',
  ];

  @override
  void initState() {
    super.initState();
    _startBalloons();
  }

  @override
  void dispose() {
    _balloonTimer?.cancel();
    for (var balloon in _balloons) {
      final timer = balloon['timer'] as Timer?;
      timer?.cancel();
    }
    super.dispose();
  }

  void _startBalloons() {    
    _balloonTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        _addBalloon();
      }
    });
  }

  void _addBalloon() {
    if (!mounted) return;
    
    if (_balloons.length > 7) {
      setState(() {
        final balloonToRemove = _balloons.first;
        final timer = balloonToRemove['timer'] as Timer?;
        timer?.cancel();
        _balloons.removeAt(0);
      });
    }
    
    final id = DateTime.now().millisecondsSinceEpoch + _random.nextInt(1000);
    
    final Map<String, dynamic> balloon = {
      'id': id,
      'message': _messages[_random.nextInt(_messages.length)],
      'left': _random.nextDouble() * 200 + 30,
      'top': _random.nextDouble() * 50 + 20,
      'opacity': 1.0,
    };
    
    final Timer removalTimer = Timer(const Duration(seconds: 20), () {
      if (mounted) {
        setState(() {
          _balloons.removeWhere((b) => b['id'] == id);
        });
      }
    });
    
    balloon['timer'] = removalTimer;
    
    setState(() {
      _balloons.add(balloon);
    });
  }

  void _removeBalloon(Map<String, dynamic> balloon) {
    final timer = balloon['timer'] as Timer?;
    timer?.cancel();
    
    setState(() {
      _balloons.remove(balloon);
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
              key: ValueKey(balloon['id']),
              message: balloon['message'] as String,
              left: balloon['left'] as double,
              top: balloon['top'] as double,
              opacity: balloon['opacity'] as double,
              onTap: () {
                _removeBalloon(balloon);
              },
            );
          }).toList(),
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
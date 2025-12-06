import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/widgets/balloon_widget.dart';

class SettingsComponent extends StatefulWidget {
  final AppController appController;

  const SettingsComponent({
    super.key,
    required this.appController,
  });

  @override
  _SettingsComponentState createState() => _SettingsComponentState();
}

class _SettingsComponentState extends State<SettingsComponent> {
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
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildAppPreferences(),
            SizedBox(height: 30),
            _buildSnoopyWithBalloons(),
            SizedBox(height: 80),
          ],
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: _buildSuggestionText(),
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
                Container(
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

  Widget _buildAppPreferences() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferências do App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFe83f3f),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingButton(
              title: 'Mostrar Introdução Novamente',
              subtitle: 'Reativa a tela de introdução',
              icon: Icons.replay,
              onTap: () async {
                await widget.appController.resetIntroPreference();
                _showSuccessSnackBar('Intro será mostrada na próxima vez!');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionText() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Text(
        'Caso você queira que eu troque algo no aplicativo ou adicione algo, pode me dizer',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildSettingButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (color ?? Color(0xFFe83f3f)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color ?? Color(0xFFe83f3f)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color ?? Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/balloon_controller.dart';
import 'package:app/widgets/balloon_area.dart';

class SettingsComponent extends StatefulWidget {
  final AppController appController;
  final BalloonController? balloonController;

  const SettingsComponent({
    super.key,
    required this.appController,
    this.balloonController,
  });

  @override
  _SettingsComponentState createState() => _SettingsComponentState();
}

class _SettingsComponentState extends State<SettingsComponent> {
  late BalloonController _balloonController;
  bool _showSuggestion = false;
  
  @override
  void initState() {
    super.initState();
    _balloonController = widget.balloonController ?? BalloonController();
    
    // DEBUG: Verificar se está iniciando
    print('Iniciando BalloonController...');
    
    // Iniciar imediatamente, não usar Future.delayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _balloonController.startSpawning();
      print('Spawn iniciado. Balões ativos: ${_balloonController.activeBalloons.length}');
    });
  }
  
  @override
  void dispose() {
    if (widget.balloonController == null) {
      _balloonController.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    print('Build SettingsComponent. Balões: ${_balloonController.activeBalloons.length}');
    
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildAppPreferences(),
            const SizedBox(height: 30),
            _buildSnoopyWithBalloons(),
            const SizedBox(height: 20),
            _buildBalloonArea(),
            const SizedBox(height: 20),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 10,
          child: _buildInfoButton(),
        ),
        if (_showSuggestion)
          Positioned(
            left: 20,
            right: 80,
            bottom: 20,
            child: _buildSuggestionText(),
          ),
      ],
    );
  }
  
  Widget _buildBalloonArea() {
    print('Criando BalloonArea...');
    return BalloonArea(
      controller: _balloonController,
      height: 150,
      topOffset: 0, // Alterado de 280 para 0
    );
  }
  
  
  Widget _buildInfoButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFe83f3f),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          _showSuggestion ? Icons.info_outline : Icons.info,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () {
          setState(() {
            _showSuggestion = !_showSuggestion;
          });
        },
        tooltip: 'Mostrar sugestões',
      ),
    );
  }

  Widget _buildSnoopyWithBalloons() {
    return SizedBox(
      height: 280,
      child: Center(
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
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      'Imagem não encontrada',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Clique nos balões abaixo!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
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
                color: const Color(0xFFe83f3f),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingButton(
              title: 'Mostrar Introdução Novamente',
              subtitle: 'Reativa a tela de introdução',
              icon: Icons.replay,
              onTap: () async {
                try {
                  await widget.appController.resetIntroPreference();
                  _showSuccessSnackBar('Intro será mostrada na próxima vez!');
                } catch (e) {
                  _showErrorSnackBar('Erro ao redefinir introdução');
                }
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
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
                color: (color ?? const Color(0xFFe83f3f)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color ?? const Color(0xFFe83f3f)),
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
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
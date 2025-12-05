import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          _buildAppPreferences(),
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
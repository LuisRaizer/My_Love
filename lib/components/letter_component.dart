import 'package:app/utils/personal_content.dart';
import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';

class LetterComponent extends StatelessWidget {
  final AppController appController;

  const LetterComponent({super.key, required this.appController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildLetterCard()),
      ],
    );
  }

  Widget _buildLetterCard() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 Uma Carta Especial para Ti',
              style: TextStyle(fontFamily: 'FredokaOne', fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(PersonalConfig.letterContent),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                PersonalConfig.letterSignature,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFe83f3f),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

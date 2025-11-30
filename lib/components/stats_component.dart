import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';

class StatsComponent extends StatelessWidget {
  final AppController appController;

  const StatsComponent({super.key, required this.appController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildStatsCard()),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '📊 Nossas Estatísticas',
              style: TextStyle(fontFamily: 'FredokaOne', fontSize: 20),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  appController.state.loveCount.toString(),
                  'Te Amo',
                ),
                _buildStatItem('127', 'Horas Discord'),
                _buildStatItem('+1000', 'Cuidado Amor'),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: appController.incrementLove,
              child: Text('+1 ❤️'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFe83f3f),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

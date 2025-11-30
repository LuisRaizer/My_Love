import 'package:flutter/material.dart';
import 'package:app/controllers/timer_controller.dart';

class TimerComponent extends StatelessWidget {
  final TimerController timerController;

  const TimerComponent({super.key, required this.timerController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildTimerCard()),
      ],
    );
  }

  Widget _buildTimerCard() {
    return ListenableBuilder(
      listenable: timerController,
      builder: (context, child) {
        return Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '❤️ Desde Nosso "Primeiro" Beijo',
                  style: TextStyle(fontFamily: 'FredokaOne', fontSize: 20),
                ),
                SizedBox(height: 16),
                Text(
                  timerController.getFormattedTime(),
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'E contando...',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

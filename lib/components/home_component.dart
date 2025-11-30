import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/timer_controller.dart';

class HomeTab extends StatelessWidget {
  final AppController appController;
  final TimerController timerController;

  const HomeTab({
    Key? key,
    required this.appController,
    required this.timerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(appController.state.themeMode == ThemeMode.light
                  ? Icons.nightlight_round
                  : Icons.wb_sunny),
              onPressed: appController.toggleTheme,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildSnoopyHouse(),
              _buildTitle(),
              _buildWishButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSnoopyHouse() {
    return Container(
      height: 350,
      child: Stack(
        children: [
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => appController.incrementLove(),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: Icon(Icons.pets, size: 60, color: Colors.black),
                  ),
                ),
                Container(
                  width: 160,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Color(0xFFe83f3f),
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Parabéns!',
      style: TextStyle(
        fontFamily: 'FredokaOne',
        fontSize: 32,
        color: Colors.white,
        shadows: [
          Shadow(
            offset: Offset(2, 2),
            blurRadius: 0,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildWishButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: appController.makeAWish,
        child: Text('✨ Fazer um Pedido ✨'),
      ),
    );
  }
}
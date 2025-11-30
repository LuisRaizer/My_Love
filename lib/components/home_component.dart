import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/timer_controller.dart';

class HomeComponent extends StatefulWidget {
  final AppController appController;
  final TimerController timerController;

  const HomeComponent({
    Key? key,
    required this.appController,
    required this.timerController,
  }) : super(key: key);

  @override
  _HomeComponentState createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(
                widget.appController.state.themeMode == ThemeMode.light
                    ? Icons.nightlight_round
                    : Icons.wb_sunny,
              ),
              onPressed: widget.appController.toggleTheme,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(children: [_buildSnoopyWithHouse(), _buildTitle()]),
        ),
      ],
    );
  }

  Widget _buildSnoopyWithHouse() {
    return Container(
      height: 400,
      child: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: () => widget.appController.incrementLove(),
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'lib/assets/snoopy.gif',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        children: [
          Text(
            'Parabéns Gadelha!',
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
                Shadow(
                  offset: Offset(4, 4),
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }
}

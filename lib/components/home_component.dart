import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/timer_controller.dart';

class HomeTab extends StatefulWidget {
  final AppController appController;
  final TimerController timerController;

  const HomeTab({
    Key? key,
    required this.appController,
    required this.timerController,
  }) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _bounceAnimation = Tween<double>(
      begin: 0,
      end: -15,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(widget.appController.state.themeMode == ThemeMode.light
                  ? Icons.nightlight_round
                  : Icons.wb_sunny),
              onPressed: widget.appController.toggleTheme,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildSnoopyWithHouse(),
              _buildTitle(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSnoopyWithHouse() {
    return Container(
      height: 400,
      child: Stack(
        children: [
          // Casa do Snoopy como GIF
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
                  child: Image.network(
                    'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNGF4dHI3cXFmbzVjOWI1ODF6d2YxYnMybGUzcXc5dW96b21wc3B2aSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/M67g2AK7Eal7G/giphy.gif',
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildFallbackSnoopy();
                    },
                  ),
                ),
              ),
            ),
          ),
          
          // Balão de pensamento
          Positioned(
            top: 50,
            right: 20,
            child: _buildThoughtBubble(),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackSnoopy() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 80, color: Colors.black),
          SizedBox(height: 10),
          Text(
            'Snoopy',
            style: TextStyle(
              fontFamily: 'FredokaOne',
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThoughtBubble() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        'Feliz Aniversário!\n🎉🎂',
        style: TextStyle(
          fontFamily: 'PatrickHand',
          fontSize: 14,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
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
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/timer_controller.dart';
import 'package:app/views/intro_view.dart';
import 'package:app/components/home_component.dart';
import 'package:app/components/letter_component.dart';
import 'package:app/components/timer_component.dart';
import 'package:app/components/stats_component.dart';
import 'package:app/components/gift_component.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  final AppController _appController = AppController();
  final TimerController _timerController = TimerController();
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _appBarTitles = [
    'Meu Amor',
    'Carta Especial',
    'Nosso Tempo',
    'Estatísticas',
    'Presente',
  ];

  @override
  void initState() {
    super.initState();
    _appController.initialize();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appController.state,
      builder: (context, child) {
        if (_appController.state.showIntro) {
          return _buildIntroWithTransition();
        }
        return _buildMainView();
      },
    );
  }

  Widget _buildIntroWithTransition() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.9,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            )),
            child: child,
          ),
        );
      },
      child: IntroView(
        key: const ValueKey('intro'),
        appController: _appController,
      ),
    );
  }

  Widget _buildMainView() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB),
              Color(0xFFD7EFFF),
              Colors.white,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildCurrentComponent(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _appController.confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _appController.toggleMusic,
              child: Icon(
                _appController.state.isMusicPlaying
                    ? Icons.volume_up
                    : Icons.volume_off,
              ),
            )
          : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          _appBarTitles[_currentIndex],
          key: ValueKey(_currentIndex),
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Color(0xFFe83f3f),
          ),
        ),
      ),
      backgroundColor: Color(0xFF87CEEB),
      shape: Border(
        bottom: BorderSide(width: 1, color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      elevation: 2,
      centerTitle: true,
    );
  }

  Widget _buildCurrentComponent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: _getCurrentComponent(),
    );
  }

  Widget _getCurrentComponent() {
    switch (_currentIndex) {
      case 0:
        return HomeComponent(
          key: const ValueKey(0),
          appController: _appController,
          timerController: _timerController,
        );
      case 1:
        return LetterComponent(
          key: const ValueKey(1),
          appController: _appController,
        );
      case 2:
        return TimerComponent(
          key: const ValueKey(2),
          timerController: _timerController,
        );
      case 3:
        return StatsComponent(
          key: const ValueKey(3),
          appController: _appController,
        );
      case 4:
        return GiftComponent(
          key: const ValueKey(4),
          appController: _appController,
        );
      default:
        return HomeComponent(
          key: const ValueKey(0),
          appController: _appController,
          timerController: _timerController,
        );
    }
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        _animationController.reset();
        setState(() {
          _currentIndex = index;
        });
        _animationController.forward();
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFFe83f3f),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.email),
          label: 'Carta',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          label: 'Tempo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Estatísticas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: 'Presente',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _appController.dispose();
    _timerController.dispose();
    super.dispose();
  }
}
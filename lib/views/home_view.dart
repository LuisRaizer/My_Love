import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/timer_controller.dart';
import 'package:app/views/intro_view.dart';
import 'package:app/components/home_component.dart';
import 'package:app/components/letter_component.dart';
import 'package:app/components/our_space_component.dart';
import 'package:app/components/love_messagens_component.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AppController _appController = AppController();
  final TimerController _timerController = TimerController();
  int _currentIndex = 0;
  int _previousIndex = 0;

  final List<String> _appBarTitles = [
    'Meu Amor',
    'Carta Especial',
    'Nosso Espaço',
    'Mensagens',
  ];

  @override
  void initState() {
    super.initState();
    _appController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appController.state,
      builder: (context, child) {
        if (_appController.state.showIntro) {
          return IntroView(appController: _appController);
        }
        return _buildMainView();
      },
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
            colors: [Color(0xFF87CEEB), Color(0xFFD7EFFF), Colors.white],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return _buildSlideTransition(child, animation);
              },
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
    );
  }

  Widget _buildSlideTransition(Widget child, Animation<double> animation) {
    final bool isGoingDown = _currentIndex > _previousIndex;

    final slideAnimation = Tween<Offset>(
      begin: Offset(0.0, isGoingDown ? -1.0 : 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final slideAnimation = Tween<Offset>(
            begin: Offset(0.0, -0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

          return SlideTransition(
            position: slideAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
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
    switch (_currentIndex) {
      case 0:
        return HomeComponent(
          key: ValueKey('home'),
          appController: _appController,
          timerController: _timerController,
        );
      case 1:
        return LetterComponent(
          key: ValueKey('letter'),
          appController: _appController,
        );
      case 2:
        return OurSpaceComponent(
          key: ValueKey('our_space'),
          appController: _appController,
          timerController: _timerController,
        );
      case 3:
        return LoveMessagesComponent();
      default:
        return HomeComponent(
          key: ValueKey('home_default'),
          appController: _appController,
          timerController: _timerController,
        );
    }
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _previousIndex = _currentIndex;
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFFe83f3f),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.email), label: 'Carta'),
        BottomNavigationBarItem(icon: Icon(Icons.space_dashboard), label: 'Nosso Espaço'),
        BottomNavigationBarItem(
          icon: Icon(Icons.messenger),
          label: 'Mensagens',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _appController.dispose();
    _timerController.dispose();
    super.dispose();
  }
}
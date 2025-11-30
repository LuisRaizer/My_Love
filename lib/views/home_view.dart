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

class _HomeViewState extends State<HomeView> {
  final AppController _appController = AppController();
  final TimerController _timerController = TimerController();
  int _currentIndex = 0;

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
              _buildCurrentComponent(),
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
        title: Text(
          _appBarTitles[_currentIndex],
          style: TextStyle(
            fontFamily: 'FredokaOne',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Color(0xFFe83f3f),
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
          appController: _appController,
          timerController: _timerController,
        );
      case 1:
        return LetterComponent(appController: _appController);
      case 2:
        return TimerComponent(timerController: _timerController);
      case 3:
        return StatsComponent(appController: _appController);
      case 4:
        return GiftComponent(appController: _appController);
      default:
        return HomeComponent(
          appController: _appController,
          timerController: _timerController,
        );
    }
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.email), label: 'Carta'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Tempo'),
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
    _appController.dispose();
    _timerController.dispose();
    super.dispose();
  }
}

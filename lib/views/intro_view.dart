import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';

class IntroView extends StatelessWidget {
  final AppController appController;

  const IntroView({Key? key, required this.appController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe83f3f),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 5),
              ),
              child: Icon(Icons.pets, size: 100, color: Colors.black),
            ),
            SizedBox(height: 20),
            Text(
              'Olha quem chegou!',
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: 24,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: appController.startApp,
              child: Text('Abrir Surpresa'),
            ),
          ],
        ),
      ),
    );
  }
}
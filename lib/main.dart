import 'package:flutter/material.dart';
import 'package:app/views/home_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feliz Aniversário Gadelha!',
      theme: ThemeData(
        primaryColor: Color(0xFFe83f3f),
        fontFamily: 'PatrickHand',
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFe83f3f),
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
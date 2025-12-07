import 'package:app/utils/personal_content.dart';
import 'package:flutter/material.dart';
import 'package:app/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: PersonalConfig.appName,
      theme: ThemeData(
        primaryColor: Color(0xFFe83f3f),
        fontFamily: 'PatrickHand',
        scaffoldBackgroundColor: const Color(0xFFfff5f5),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFe83f3f),
          unselectedItemColor: Colors.grey,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFe83f3f),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:zawtika/app_config/app_config.dart';
import 'package:zawtika/screen/home_screen.dart';

import 'app_config/my_theme.dart';
import 'screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        "/": (context) => const SplashScreen(),
        "/home": (context) => const HomePage(),
      },
      title: AppConfig.app_name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyTheme.white,
        appBarTheme: AppBarTheme(color: MyTheme.splash_screen_color),
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: MyTheme.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

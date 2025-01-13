import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shogo/screens/main_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final String splashImage = isDarkMode ? 'assets/shogo_night.png' : 'assets/shogo.png';

    return AnimatedSplashScreen(
      splash: SizedBox(
        width: 250,
        height: 250,
        child: Image.asset(splashImage, fit: BoxFit.contain),
      ),
      nextScreen: const MainScreen(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:weather_app_flutter2_5/src/screen/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
          duration: 2000,
          splash: const Scaffold(
            body: Center(child: Text("Splash Screen"),),
          ),
          nextScreen: const HomeScreen(),
          splashTransition: SplashTransition.fadeTransition,
          // backgroundColor: Colors.blue
    );
  }
}
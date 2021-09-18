import 'package:flutter/material.dart';
import 'package:weather_app_flutter2_5/src/screen/home_screen.dart';
import 'package:weather_app_flutter2_5/src/screen/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/splash': (context) => const SplashScreen(),
        // '/loaction': (context) => LocationScreen(),
      },
    );
  }
}
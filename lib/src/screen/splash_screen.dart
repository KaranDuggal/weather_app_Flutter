import 'package:flutter/material.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:weather_app_flutter2_5/src/screen/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    navigateToHome();
  }

  void navigateToHome()async{
    await Future.delayed(const Duration(seconds: 2),(){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (contaxt)=> const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/WAlogo.png',height:300,width: 300,),
            const Text(
              "Wether App",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            const Text(
              "Made BY Duggal",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20,),
            SpinKitSpinningLines(
              color: Colors.blue.shade400,
              size: 50.0,
            )
          ],
        ),
      ), 
      backgroundColor: Colors.blue.shade200,
    );
  }
}
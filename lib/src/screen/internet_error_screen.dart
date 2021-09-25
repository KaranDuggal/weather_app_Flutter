import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InternetErrorScreen extends StatelessWidget {
  const InternetErrorScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Colors.blue.shade300,
          ),
        ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            stops: const [
              0.1,
              0.9
            ],
            colors: [
              Colors.blue.shade300,
              Colors.orange.shade300
            ]
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Interne Connection lost",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 20,),
              SpinKitCircle(
                color: Colors.blue.shade400,
                size: 50.0,
              )
            ],
          ),
        ),
      ), 
      backgroundColor: Colors.blue.shade200,
    );
  }
}
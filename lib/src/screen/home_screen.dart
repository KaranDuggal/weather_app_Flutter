import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (BuildContext contaxt, AsyncSnapshot<ConnectivityResult> snapshot){
          if(snapshot.hasData && snapshot.data != ConnectivityResult.none){
            return const Center(child: Text("connected"));
          }else{
            return const Center(child: Text("Not connected"));
          }
        },
      )
    );
  }
}
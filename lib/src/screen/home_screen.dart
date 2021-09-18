import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geocoder/geocoder.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var weatherInfo;
  var weatherOldInfo;
  bool apiHit = false;
  String search = '';
  String sunrise = '';
  String sunset = '';
  String defaltCity = 'jalandhar';
  @override
  void initState(){
    super.initState();
    _determinePosition();
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    await Geolocator.openLocationSettings();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {return Future.error('Location permissions are denied');}
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } 
    Position coordinates = await Geolocator.getCurrentPosition();
    var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(coordinates.latitude, coordinates.longitude));
    return coordinates;
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
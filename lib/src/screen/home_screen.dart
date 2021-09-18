import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:weather_app_flutter2_5/src/models/weather_data.dart';
import 'package:weather_app_flutter2_5/src/services/api_service.dart';
import 'package:intl/intl.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ignore: prefer_typing_uninitialized_variables
  var weatherInfo;
  // ignore: prefer_typing_uninitialized_variables
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
    getData("jalandhar");
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
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
  Future <void> getData (city) async {
    var data = await ApiService().get(city);
    weatherOldInfo = weatherInfo;
    weatherInfo = Weatherdata.fromJson(jsonDecode(data));
    apiHit = true;
    if(weatherInfo!.cod == 200){
      // await Future.delayed(Duration(seconds: 2));dd MMMM yyyy, hh:mm a
      sunrise = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(weatherInfo.sys.sunrise *1000));
      sunset = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(weatherInfo.sys.sunset *1000));
      print('sunrise $sunrise , sunset $sunset ');
      setState(() {

      });
    }else{
      weatherInfo = weatherOldInfo;
      setState(() {

      });
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Invalid City Name '$search'",
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (BuildContext contaxt, AsyncSnapshot<ConnectivityResult> snapshot){
          if(snapshot.hasData && snapshot.data != ConnectivityResult.none){
            return apiHit ? const Center(child: Text("connected")) : const Center(child: Text("fetching data"));
          }else{
            return const Center(child: Text("Not connected"));
          }
        },
      )
    );
  }
}
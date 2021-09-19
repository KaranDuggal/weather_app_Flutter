import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:weather_app_flutter2_5/src/models/weather_data.dart';
import 'package:weather_app_flutter2_5/src/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  bool isInternetOn = false;
  String search = '';
  String sunrise = '';
  String sunset = '';
  String defaltCity = 'jalandhar';
  @override
  void initState(){
    super.initState();
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await getData(defaltCity);
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) { 
        await getData(defaltCity); 
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await getData(defaltCity);
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } 
    Position coordinates = await Geolocator.getCurrentPosition();
    var address = await Geocoder.local.findAddressesFromCoordinates(Coordinates(coordinates.latitude, coordinates.longitude));
    if(address.first.subAdminArea!.isNotEmpty){
      defaltCity = address.first.subAdminArea!;
    }
    await getData(defaltCity);
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
      setState(() {
      });
    }else{
      weatherInfo = weatherOldInfo;
      Alert(
        context: context,
        title: "ERROR !!!",
        desc: "Invalid city name. \"$search\"",
      ).show();
      setState(() {
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    String city = "Mumbai";
    return Scaffold(
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (BuildContext contaxt, AsyncSnapshot<ConnectivityResult> snapshot){
          if(snapshot.hasData && snapshot.data != ConnectivityResult.none){
            if(isInternetOn == false){
              _determinePosition();
              isInternetOn = true;
            }
            return apiHit 
            ? 
            SingleChildScrollView(
              child: SafeArea(
                // BackGround
                child: Container(
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
                  child: Column(
                    children: [
                      Container( // search bar
                        // color: Colors.grey,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 24
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width:10),
                            GestureDetector(
                              onTap: () async {
                                if(search.isNotEmpty){
                                  apiHit = false;
                                  setState(() {
                                  });
                                  await getData(search);
                                }
                              },
                              child: const Icon(Icons.search),
                            ),
                            const SizedBox(width:10),
                            Expanded( 
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (value) async{
                                  if(value.isNotEmpty){
                                    apiHit = false;
                                    setState(() {
                                    });
                                    await getData(search);
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Search any city name eg. $city",
                                  border: InputBorder.none
                                ),
                                onChanged: (value){
                                  search = value;
                                },
                              )
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                children: [
                                  Image.network("https://openweathermap.org/img/wn/${weatherInfo.weather[0].icon}.png"),
                                  // Image.asset('assets/images/snowyoutline.png',height: 50,width: 50,),
                                  const SizedBox(width: 10,height: 50,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${weatherInfo.weather[0].description}"
                                      ),
                                      Text(
                                        "in ${weatherInfo.name}, ${weatherInfo.sys.country}"
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "sunrise :- $sunrise"
                                            ),
                                            Text(
                                              "sunset :-  $sunset"
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Image.asset('assets/images/temp.png',height: 50,width: 50,),
                                  // Image.network("https://toppng.com/uploads/preview/temperature-free-icon-temperature-icon-free-11553469636smayyrvo21.png",height: 50,width: 50,),
                                  Row(
                                    mainAxisAlignment : MainAxisAlignment.center,
                                    children: [
                                      Text("${weatherInfo.main.temp}",style: const TextStyle(fontSize: 70) ,),
                                      const Text("C",style: TextStyle(fontSize: 40))
                                    ],
                                  )
                                ]
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              height: 150,
                              margin: const EdgeInsets.fromLTRB(20 , 0, 10, 0),
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Image.asset('assets/images/wind.png',height: 30,width: 30,),
                                  Row(
                                    mainAxisAlignment : MainAxisAlignment.center,
                                    children: [
                                      Text("${weatherInfo.wind.speed}",style: const TextStyle(fontSize: 20) ,),
                                      const SizedBox(width: 5,),
                                      const Text("Km/hr",style: TextStyle(fontSize: 15))
                                    ],
                                  )
                                ]
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 150,
                              margin: const EdgeInsets.fromLTRB(10 , 0, 20, 0),
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Image.asset('assets/images/humidity.png',height: 30,width: 30,),
                                  Row(
                                    mainAxisAlignment : MainAxisAlignment.center,
                                    children: [
                                      Text("${weatherInfo.main.humidity}",style: const TextStyle(fontSize: 20) ,),
                                      const SizedBox(width: 5,),
                                      const Text("Percent",style: TextStyle(fontSize: 15))
                                    ],
                                  )
                                ]
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      const Text("Data Provided By Openweathermap.org"),
                      // SizedBox(height: 100,),
                    ],
                  ),
                )
              ),
            )
            : 
            const Center(child: Text("fetching data"));
          }else{
            if(isInternetOn == true){
              isInternetOn = false;
            }
            return const Center(child: Text("Not connected"));
          }
        },
      )
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_test/weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String data;

  MyHomePage(this.data);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var apikey = '686ed040c1a472d18875dc26bf740e60';
  String lat = "";
  String lang = "";

  String temp = "";
  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      //nothing
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);

    var ctempresponse = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=' +
            position.latitude.toString() +
            '&lon=' +
            position.longitude.toString() +
            '&appid=' +
            apikey +
            '&units=metric'));

    print(ctempresponse.body);
    var data = json.decode(ctempresponse.body);

    return data;
  }

  // getcurrentTemp() {
  //   getLocation().then((value) async {
  //     var ctempresponse = await http.get(Uri.parse(
  //         'https://api.openweathermap.org/data/2.5/weather?lat=' +
  //             value.latitude.toString() +
  //             '&lon=' +
  //             value.longitude.toString() +
  //             '&appid=' +
  //             apikey));
  //   });

  //   var data = json.decode(ctempresponse.body);

  //   return data;
  // }

  @override
  void initState() {
    super.initState();

    getLocation().then((data) {
      setState(() {
        temp = data['main']['temp'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    getLocation().then((data) {
                      print("DATA");
                      setState(() {
                        print(widget.data);
                        widget.data = "";

                        widget.data.isEmpty == true
                            ? temp = temp.toString()
                            : temp = widget.data.toString();
                      });
                    });
                  });
                },
                icon: Icon(Icons.home)),
            Text('Weather App'),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WeatherPage()));
              },
              icon: Icon(Icons.arrow_forward))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Current Weather : ',
            ),
            Text(
              widget.data.isEmpty == true
                  ? temp.toString()
                  : widget.data.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     getLocation().then((value) {
      //       print("object");
      //       print(value.latitude);
      //       print(value.longitude);
      //     });
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

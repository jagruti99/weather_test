import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'main.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  TextEditingController _controller = TextEditingController();
  var apikey = '686ed040c1a472d18875dc26bf740e60';
  getweathersearch(value) async {
    var wresponse = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?appid=' +
            apikey +
            '&q=' +
            value.toString() +
            '&units=metric'));

    var data = json.decode(wresponse.body)['main']['temp'];

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                // searchData(st = value.trim().toLowerCase());
                // Method For Searching
              },
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter city name",
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _controller.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
                child: Text("Get Weather"),
                onPressed: () {
                  print(_controller.text.toString());

                  getweathersearch(_controller.text.toString()).then((data) {
                    print("object");

                    print(data);
                    double v = double.parse(data.toString());

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(v.toString())));
                  });
                }),
          ],
        ),
      )),
    );
  }
}

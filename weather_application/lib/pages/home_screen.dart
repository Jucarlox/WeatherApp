import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:weather_application/models/city.dart';
import 'package:weather_application/models/weather_city.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:date_format/date_format.dart';
import 'package:weather_application/pages/details_weather.dart';

late String citySelect = "";
late double latSelected = 0;
late double lngSelected = 0;

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
      primarySwatch: Colors.blue,
    ),
    home: const HomeScreen(),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<HomeScreen> createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<HomeScreen> {
  late Future<WeatherCityResponse> items;
  late BuildContext _context;

  @override
  void initState() {
    items = fetchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    //citySelect = ModalRoute.of(context)!.settings.name as String;

    if (latSelected == 0) {
      return Scaffold(
        body: Container(
            child: const Center(
              child: Text(
                "Ninguna ciudad seleccionada",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/tierra.jpg",
                    ),
                    fit: BoxFit.cover))),
      );
    } else {
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/tierra.jpg",
                  ),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              FutureBuilder<WeatherCityResponse>(
                future: items,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return dates(snapshot.data!);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )
            ],
          ),
        ),
      );
    }
  }

  Future<WeatherCityResponse> fetchWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    latSelected = prefs.getDouble('lat')!;
    lngSelected = prefs.getDouble('lng')!;

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latSelected&lon=$lngSelected&appid=b67e3a6f41956f3d2f21725d8148ee93'));
    if (response.statusCode == 200) {
      return WeatherCityResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load planets');
    }
  }

  Widget dates(WeatherCityResponse response) {
    String _selectedDateTime =
        formatDate(DateTime.now(), [DD, ", ", dd, " ", MM, " ", yyyy]);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 45, 0, 30),
          child: Text(
            response.name,
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.blue.shade100.withOpacity(0.8),
          child: InkWell(
            splashColor: Colors.blue,
            onTap: () {},
            child: SizedBox(
              width: 300,
              height: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Text(_selectedDateTime),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (response.main.temp - 273).toStringAsFixed(
                            1,
                          ),
                          style: TextStyle(fontSize: 70, color: Colors.black),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Text(
                            "°C",
                            style: TextStyle(fontSize: 40, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.blue.shade100.withOpacity(0.8),
            child: InkWell(
              splashColor: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DetailsWeather()),
                );
              },
              child: SizedBox(
                width: 230,
                height: 230,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                      child: SizedBox(
                        height: 100,
                        width: 200,
                        child: Image.network(
                          'http://openweathermap.org/img/wn/' +
                              response.weather[0].icon +
                              '@2x.png',
                          width: 100,
                        ),
                      ),
                    ),
                    Text(response.weather[0].main)
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 5, 50, 0),
              child: Row(
                children: [
                  Text(
                      (response.main.tempMax - 273).toStringAsFixed(
                        1,
                      ),
                      style: TextStyle(color: Colors.white)),
                  const Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 100, 0),
              child: Row(
                children: [
                  Text(
                      (response.main.tempMin - 273).toStringAsFixed(
                        1,
                      ),
                      style: TextStyle(color: Colors.white)),
                  const Icon(
                    Icons.arrow_downward_rounded,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

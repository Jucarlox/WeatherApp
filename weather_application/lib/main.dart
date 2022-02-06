import 'package:flutter/material.dart';
import 'package:weather_application/models/weather_city.dart';

import 'pages/details_weather.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/home': (context) => const Home(),
        '/details_weather': (context) => const DetailsWeather(),
      },
    );
  }
}

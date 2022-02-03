import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:weather_application/models/weather_city.dart';

void main() {
  runApp(const HomeScreen());
}

late Future<WeatherCityResponse> weather;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (1 == 2) {
      return const MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
          body: Center(
            child: Text('Hello World'),
          ),
        ),
      );
    } else {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            //child: weather,
            child: Text("Hola hola"),
          ),
        ),
      );
    }
  }
}

Future<WeatherCityResponse> fetchWeather() async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=sevilla&lang=es&appid=b67e3a6f41956f3d2f21725d8148ee93'));
  if (response.statusCode == 200) {
    return WeatherCityResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load people');
  }
}

Widget Name(WeatherCityResponse patata) {
  return Text(patata.name);
}

import 'package:flutter/material.dart';

import 'package:weather_application/models/weather_city.dart';

class DetailsWeather extends StatefulWidget {
  const DetailsWeather({Key? key}) : super(key: key);

  @override
  _DetailsWeatherPageState createState() => _DetailsWeatherPageState();
}

class _DetailsWeatherPageState extends State<DetailsWeather> {
  @override
  Widget build(BuildContext context) {
    //final response =ModalRoute.of(context)!.settings.arguments as WeatherCityResponse;

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("response.weather[0].main"),
    ));
  }
}

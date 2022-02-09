import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_application/models/days.dart';
import 'package:weather_application/models/one_call.dart';
import 'package:weather_application/models/weather_city.dart';

void main() => runApp(const DetailsWeather());

late double latSelected = 0;
late double lngSelected = 0;
late String citiSelect = "";

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
    home: const DetailsWeather(),
  );
}

class DetailsWeather extends StatefulWidget {
  const DetailsWeather({Key? key}) : super(key: key);

  @override
  State<DetailsWeather> createState() => _DetailsWeatherPageState();
}

class _DetailsWeatherPageState extends State<DetailsWeather> {
  late Future<List<Hourly>> hourlyWeather;
  late Future<List<Daily>> dailyWeather;

  @override
  void initState() {
    //currentWeather = fetchWeather();
    dailyWeather = fetchDaily();
    hourlyWeather = fetchHourly();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final response =ModalRoute.of(context)!.settings.arguments as WeatherCityResponse;

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/tierra.jpg",
                    ),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 50),
                        child: FutureBuilder<List<Daily>>(
                            future: dailyWeather,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return _dailyList(snapshot.data!);
                              } else if (snapshot.hasError) {
                                return Text(
                                  '${snapshot.error}',
                                  style: TextStyle(color: Colors.white),
                                );
                              }

                              return const Center(
                                  child: CircularProgressIndicator());
                            }),
                      ),
                      FutureBuilder<List<Hourly>>(
                          future: hourlyWeather,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return _hourlyList(snapshot.data!);
                            } else if (snapshot.hasError) {
                              return Text(
                                '${snapshot.error}',
                                style: TextStyle(color: Colors.white),
                              );
                            }

                            return const Center(
                                child: CircularProgressIndicator());
                          })
                    ],
                  ),
                )
              ],
            )));
  }

  Future<List<Daily>> fetchDaily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    latSelected = prefs.getDouble('lat')!;
    lngSelected = prefs.getDouble('lng')!;

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=${latSelected}&lon=${lngSelected}&exclude=minutely&appid=b67e3a6f41956f3d2f21725d8148ee93&units=metric'));
    if (response.statusCode == 200) {
      return OneCallModel.fromJson(jsonDecode(response.body)).daily;
    } else {
      throw Exception('Failed to load planets');
    }
  }

  Future<List<Hourly>> fetchHourly() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    latSelected = prefs.getDouble('lat')!;
    lngSelected = prefs.getDouble('lng')!;

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=${latSelected}&lon=${lngSelected}&exclude=minutely&appid=b67e3a6f41956f3d2f21725d8148ee93&units=metric'));
    if (response.statusCode == 200) {
      return OneCallModel.fromJson(jsonDecode(response.body)).hourly;
    } else {
      throw Exception('Failed to load planets');
    }
  }

  Future<WeatherCityResponse> fetchWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lat = prefs.getDouble('lat');
    var lng = prefs.getDouble('lng');

    latSelected = lat!;
    lngSelected = lng!;
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${latSelected}&lon=${lngSelected}&appid=b67e3a6f41956f3d2f21725d8148ee93'));
    if (response.statusCode == 200) {
      return WeatherCityResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load planets');
    }
  }

  Widget _hourlyList(List<Hourly> hourlyResponse) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 24,
          itemBuilder: (context, index) {
            return _hourlyItem(hourlyResponse.elementAt(index), index);
          }),
    );
  }

  Widget _hourlyItem(Hourly hour, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.blue.shade100.withOpacity(0.8),
        ),
        child: Column(
          children: [
            Text(formatDate(listaHoras[index].hora, [HH, ":00 h"])),
            Image.asset(
              'assets/${hour.weather[0].icon}.png',
              width: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dailyList(List<Daily> dailyResponse) {
    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dailyResponse.length,
          itemBuilder: (context, index) {
            return _dailyItem(dailyResponse.elementAt(index), index);
          }),
    );
  }

  Widget _dailyItem(Daily daily, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.blue.shade100.withOpacity(0.8),
        ),
        child: Column(
          children: [
            Text(formatDate(listaDias[index].day, [DD])),
            /*Image.network('http://openweathermap.org/img/wn/' +
                daily.weather[0].icon +
                '.png'),*/

            Text(daily.temp.day.toString()),
          ],
        ),
      ),
    );
  }
}

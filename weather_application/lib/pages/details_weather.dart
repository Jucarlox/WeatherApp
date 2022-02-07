import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_application/models/city.dart';
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
    var index = prefs.getInt('indexCity');
    citiSelect = coord[index!].city;
    latSelected = coord[index].lat;
    lngSelected = coord[index].lng;

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
    var index = prefs.getInt('indexCity');
    citiSelect = coord[index!].city;

    var latSelected = prefs.getDouble('lat');
    var lngSelected = prefs.getDouble('lng');

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=${latSelected}&lon=${lngSelected}&exclude=minutely&appid=b67e3a6f41956f3d2f21725d8148ee93&units=metric'));
    if (response.statusCode == 200) {
      return OneCallModel.fromJson(jsonDecode(response.body)).hourly;
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
          itemCount: hourlyResponse.length,
          itemBuilder: (context, index) {
            return _hourlyItem(hourlyResponse.elementAt(index), index);
          }),
    );
  }

  Widget _hourlyItem(Hourly hour, int index) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.blue[800]?.withOpacity(0.8),
      ),
      child: Column(
        children: [
          Text(
            hour.pressure.toString(),
          )
        ],
      ),
    );
  }

  Widget _dailyList(List<Daily> dailyResponse) {
    return SizedBox(
      height: 100,
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
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.blue[800]?.withOpacity(0.8),
      ),
      child: Column(
        children: [
          Text(
            daily.pressure.toString(),
          ),
          Image.network('http://openweathermap.org/img/wn/' +
              daily.weather[0].icon +
              '.png'),
          Text(daily.temp.day.toString()),
        ],
      ),
    );
  }
}

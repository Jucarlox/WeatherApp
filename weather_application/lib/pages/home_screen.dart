import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:weather_application/models/days.dart';
import 'package:weather_application/models/one_call.dart';
import 'package:weather_application/models/weather_city.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:date_format/date_format.dart';
import 'package:weather_application/pages/details_weather.dart';
import 'package:google_fonts/google_fonts.dart';

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
  late Future<List<Hourly>> hourlyWeather;
  late Future<List<Daily>> dailyWeather;

  @override
  void initState() {
    items = fetchWeather();
    dailyWeather = fetchDaily();
    hourlyWeather = fetchHourly();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //citySelect = ModalRoute.of(context)!.settings.name as String;

    if (latSelected == 0) {
      return Scaffold(
        body: Container(
          color: Colors.black,
          child: const Center(
            child: Text(
              "Ninguna ciudad seleccionada",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
          body: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black,
                  child: SafeArea(
                      child: Stack(children: [
                    SingleChildScrollView(
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
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white.withOpacity(0.05),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      child: Text(
                                        'Pronóstico 24 horas',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: FutureBuilder<List<Hourly>>(
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
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white.withOpacity(0.05),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      child: Text(
                                        'Pronóstico 7 dias',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
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
                        ],
                      ),
                    )
                  ])))));
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

  Widget _hourlyList(List<Hourly> hourlyResponse) {
    return SizedBox(
      height: 150,
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
        width: 150,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.007,
              ),
              child: Text(
                formatDate(listaHoras[index].hora, [HH, ":00 h"]),
                style: GoogleFonts.questrial(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              'assets/${hour.weather[0].icon}.png',
              width: 90,
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.0023,
              ),
              child: Text(
                hour.temp.toString(),
                style: GoogleFonts.questrial(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dailyList(List<Daily> dailyResponse) {
    return SizedBox(
      height: 330,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 7,
          itemBuilder: (context, index) {
            return _dailyItem(dailyResponse.elementAt(index), index);
          }),
    );
  }

  Widget _dailyItem(Daily daily, int index) {
    Size size = MediaQuery.of(context).size;
    double min = (daily.temp.min);
    double max = (daily.temp.max);
    return Padding(
      padding: EdgeInsets.all(
        size.height * 0.005,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                ),
                child: Text(
                  formatDate(listaDias[index].day, [DD],
                      locale: const SpanishDateLocale()),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.25,
                ),
                child: Image.asset(
                  'assets/${daily.weather[0].icon}.png',
                  height: size.height * 0.06,
                  color: Colors.white,
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.15,
                  ),
                  child: Text(
                    min.toStringAsFixed(1) + '˚C',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                  ),
                  child: Text(
                    max.toStringAsFixed(1) + '˚C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget dates(WeatherCityResponse response) {
    String _selectedDateTime = formatDate(
        DateTime.now(), [DD, ", ", dd, " ", MM, " ", yyyy],
        locale: const SpanishDateLocale());
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.07,
          ),
          child: Align(
            child: Text(
              response.name,
              style: GoogleFonts.questrial(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.height * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.020,
              ),
              child: Align(
                child: Text(
                  _selectedDateTime, //day
                  style: GoogleFonts.questrial(
                    color: Colors.white70,
                    fontSize: MediaQuery.of(context).size.height * 0.030,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.020,
              ),
              child: Image.asset(
                'assets/${response.weather[0].icon}.png',
                width: 100,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (response.main.temp - 273).toStringAsFixed(
                      0,
                    ),
                    style: GoogleFonts.questrial(
                      color: (response.main.temp - 273) <= 0
                          ? Colors.blue
                          : (response.main.temp - 273) > 0 &&
                                  (response.main.temp - 273) <= 15
                              ? Colors.indigo
                              : (response.main.temp - 273) > 15 &&
                                      (response.main.temp - 273) < 30
                                  ? Colors.deepPurple
                                  : Colors.pink,
                      fontSize: MediaQuery.of(context).size.height * 0.13,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.00,
                    ),
                    child: Text(
                      "°C",
                      style: GoogleFonts.questrial(
                        color: (response.main.temp - 273) <= 0
                            ? Colors.blue
                            : (response.main.temp - 273) > 0 &&
                                    (response.main.temp - 273) <= 15
                                ? Colors.indigo
                                : (response.main.temp - 273) > 15 &&
                                        (response.main.temp - 273) < 30
                                    ? Colors.deepPurple
                                    : Colors.pink,
                        fontSize: MediaQuery.of(context).size.height * 0.13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.005,
              ),
              child: Align(
                child: Text(
                  response.weather[0].main, // weather
                  style: GoogleFonts.questrial(
                    color: Colors.white70,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(response.main.tempMin - 273).toStringAsFixed(
                      0,
                    )}˚C', // min temperature
                    style: GoogleFonts.questrial(
                      color: (response.main.tempMin - 273) <= 0
                          ? Colors.blue
                          : (response.main.tempMin - 273) > 0 &&
                                  (response.main.tempMin - 273) <= 15
                              ? Colors.indigo
                              : (response.main.tempMin - 273) > 15 &&
                                      (response.main.tempMin - 273) < 30
                                  ? Colors.deepPurple
                                  : Colors.pink,
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ),
                  Text(
                    '/',
                    style: GoogleFonts.questrial(
                      color: Colors.white54,
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ),
                  Text(
                    '${(response.main.tempMax - 273).toStringAsFixed(
                      0,
                    )}˚C', //max temperature
                    style: GoogleFonts.questrial(
                      color: (response.main.tempMax - 273) <= 0
                          ? Colors.blue
                          : (response.main.tempMax - 273) > 0 &&
                                  (response.main.tempMax - 273) <= 15
                              ? Colors.indigo
                              : (response.main.tempMax - 273) > 15 &&
                                      (response.main.tempMax - 273) < 30
                                  ? Colors.deepPurple
                                  : Colors.pink,
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}






/**Padding(
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
                          child: Image.asset(
                            'assets/${response.weather[0].icon}.png',
                            width: 100,
                          )),
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
                        0,
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
                        0,
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
        ) */
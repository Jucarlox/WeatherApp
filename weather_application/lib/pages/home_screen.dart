import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:weather_application/models/city.dart';
import 'package:weather_application/models/weather_city.dart';
import 'package:shared_preferences/shared_preferences.dart';

late String citySelect = "";

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

  @override
  void initState() {
    items = fetchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //citySelect = ModalRoute.of(context)!.settings.name as String;

    if (citySelect == "") {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('No hay ciudad seleccionada'),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(50.0),
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
    var index = prefs.getInt('indexCity');
    citySelect = ListaCiudades[index!].city;

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=${citySelect}&lang=es&appid=b67e3a6f41956f3d2f21725d8148ee93'));
    if (response.statusCode == 200) {
      return WeatherCityResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load planets');
    }
  }

  /* Widget _planetItem(Current planet) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        width: 150,
        child: Card(
          child: InkWell(
            splashColor: Colors.red.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
            },
            child: SizedBox(
              width: 30,
              height: 400,
              child: Column(
                children: [
                  Text(planet.visibility.toString()),
                ],
              ),
            ),
          ),
        ));
  }*/
  Widget name(WeatherCityResponse response) {
    return Text(response.name);
  }

  Widget dates(WeatherCityResponse response) {
    return Column(
      children: [
        Text(response.name),
        Text(response.coord.lat.toString()),
        Text(response.coord.lon.toString())
      ],
    );
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

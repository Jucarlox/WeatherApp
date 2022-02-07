import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:weather_application/models/city.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
      home: const SelectCity(),
    );
  }
}

class SelectCity extends StatefulWidget {
  const SelectCity({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<SelectCity> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SelectCity> {
  late Future<List<LocationModel>> items;

  @override
  void initState() {
    items = fetchPeople();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
            body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/tierra.jpg",
                  ),
                  fit: BoxFit.cover)),
          child: TabBarView(
            children: [
              Center(
                child: FutureBuilder<List<LocationModel>>(
                  future: items,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _cityList(snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Future<List<LocationModel>> fetchPeople() async {
    return coord;
  }

  Widget _cityList(List<LocationModel> peopleList) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: peopleList.length,
        itemBuilder: (context, index) {
          return _cityItem(peopleList.elementAt(index), index);
        },
      ),
    );
  }

  Widget _cityItem(LocationModel location, int index) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        width: 150,
        child: Card(
          child: InkWell(
            splashColor: Colors.red.withAlpha(30),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('indexCity', index);
            },
            child: SizedBox(
              width: 300,
              height: 150,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                    child: Text(
                      location.city,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

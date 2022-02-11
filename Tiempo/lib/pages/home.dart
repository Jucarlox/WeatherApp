import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:Tiempo/pages/home_screen.dart';
import 'package:Tiempo/pages/mapa.dart';
import 'package:Tiempo/pages/moon.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    MapClickPage(),
    HomeScreen(),
    MoonScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Image.asset(
            "assets/planeta-tierra.png",
            width: 40,
          ),
          Image.asset(
            "assets/ubicacion.png",
            width: 40,
          ),
          Image.asset(
            "assets/marte.png",
            width: 40,
          )
        ],
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        animationDuration: const Duration(milliseconds: 1500),
        animationCurve: Curves.decelerate,
        color: Colors.black,
        buttonBackgroundColor: Colors.lightBlueAccent,
        index: _selectedIndex,
        height: 60,
      ),
    );
  }
}

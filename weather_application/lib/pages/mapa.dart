// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_application/models/map.dart';

CameraPosition _kInitialPosition =
    CameraPosition(target: LatLng(37.3754865, -6.0250989), zoom: 11.0);

class MapClickPage extends GoogleMapExampleAppPage {
  const MapClickPage() : super(const Icon(Icons.mouse), 'Map click');
  @override
  Widget build(BuildContext context) {
    return const _MapClickBody();
  }
}

class _MapClickBody extends StatefulWidget {
  const _MapClickBody();
  @override
  State<StatefulWidget> createState() => _MapClickBodyState();
}

class _MapClickBodyState extends State<_MapClickBody> {
  GoogleMapController? mapController;
  LatLng _lastTap = LatLng(0, 0);
  LatLng? _lastLongPress;
  @override
  void initState() {
    super.initState();
    coordenadas();
  }

  coordenadas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getDouble('lat') != null) {
      double? lat = prefs.getDouble('lat');
      double? lng = prefs.getDouble('lng');
      _lastTap = LatLng(lat!, lng!);
      _kInitialPosition = CameraPosition(target: _lastTap, zoom: 11.0);
    } else {
      _kInitialPosition = const CameraPosition(
          target: LatLng(37.3754865, -6.0250989), zoom: 11.0);
      return _lastTap = const LatLng(37.3754865, -6.0250989);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoogleMap googleMap = GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      onTap: (LatLng pos) async {
        setState(() {
          _lastTap = pos;
          coordenadas();
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setDouble('lat', pos.latitude);
        prefs.setDouble('lng', pos.longitude);
      },
      markers: <Marker>{_createMarker()},
      onLongPress: (LatLng pos) {
        setState(() {
          _lastLongPress = pos;
        });
      },
    );
    final List<Widget> columnChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 155,
            child: googleMap,
          ),
        ),
      ),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: buscador(),
        ),
        Column(
          children: columnChildren,
        ),
      ],
    );
  }

  List<Widget> buscador() {
    return <Widget>[
      // Replace this container with your Map widget
      Container(
        color: Colors.black,
      ),
      Positioned(
        top: 10,
        right: 15,
        left: 15,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 0),
            child: Row(
              children: const <Widget>[
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: "Search..."),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
  }

  Marker _createMarker() {
    return Marker(
      markerId: MarkerId("marker_1"),
      position: _lastTap,
    );
  }
}

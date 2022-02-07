// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_application/models/map.dart';

const CameraPosition _kInitialPosition =
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
  _MapClickBodyState();
  GoogleMapController? mapController;
  LatLng? _lastTap;
  LatLng? _lastLongPress;
  @override
  Widget build(BuildContext context) {
    final GoogleMap googleMap = GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      onTap: (LatLng pos) {
        setState(() async {
          _lastTap = pos;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setDouble('lat', pos.latitude);
          prefs.setDouble('lng', pos.longitude);
        });
      },
      onLongPress: (LatLng pos) {
        setState(() async {
          _lastLongPress = pos;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setDouble('lat', pos.latitude);
          prefs.setDouble('lng', pos.longitude);
        });
      },
    );
    final List<Widget> columnChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            child: googleMap,
          ),
        ),
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
  }
}



/**onTap: (LatLng pos) {
        setState(() async {
          _lastTap = pos;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setDouble('lat', pos.latitude);
        });
      },
      onLongPress: (LatLng pos) {
        setState(() async {
          _lastLongPress = pos;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setDouble('lng', pos.longitude);
        });
      }, */
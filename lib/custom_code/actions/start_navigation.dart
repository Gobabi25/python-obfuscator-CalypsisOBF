// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

Future startNavigation(
  dynamic depart,
  dynamic arrivee,
  List<dynamic>? arret,
) async {
  // Add your function code here!
  print("=====le depart===== ${depart!["latitude"]}");
  final departurePoint = WayPoint(
    name: depart["display_name"],
    latitude: depart!["latitude"],
    longitude: depart!["longitude"],
  );

  //  WayPoint? arretPoint;
  // if (servicesListData!.stopLongitude != null) {
  //  arretPoint = WayPoint(
  //    name: "Arrêt",
  //    latitude: double.parse(servicesListData!.stopLatitude!),
  //    longitude: double.parse(servicesListData!.stopLongitude!),
  //  );
  //}

  final arrivalPoint = WayPoint(
    name: arrivee["display_name"],
    latitude: arrivee!["latitude"],
    longitude: arrivee!["longitude"],
  );
// Créez les WayPoint pour les arrêts
  List<WayPoint> wayPoints = [departurePoint];
  if (arret != null && arret.isNotEmpty) {
    for (var stop in arret) {
      final stopPoint = WayPoint(
        name: stop["display_name"],
        latitude: stop!["latitude"],
        longitude: stop!["longitude"],
      );
      wayPoints.add(stopPoint);
    }
  }
  wayPoints.add(arrivalPoint);

  MapBoxNavigation.instance.setDefaultOptions(
    MapBoxOptions(
      initialLatitude: departurePoint.latitude,
      initialLongitude: departurePoint.longitude,
      zoom: 13.0,
      tilt: 0.0,
      bearing: 0.0,
      enableRefresh: true,
      alternatives: false,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      allowsUTurnAtWayPoints: false,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      mapStyleUrlDay:
          "mapbox://styles/terranutraespciale/cm6h0141h004q01sa73nhf3ea",
      units: VoiceUnits.metric,
      // simulateRoute: true,
      language: "fr",
    ),
  );

  await MapBoxNavigation.instance.startNavigation(
      //wayPoints: arretPoint == null
      //  ?
      wayPoints: wayPoints
      // : [departurePoint, arretPoint, arrivalPoint],
      );
}

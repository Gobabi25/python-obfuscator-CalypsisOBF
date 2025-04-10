// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:map_launcher/map_launcher.dart' as map;

Future mapRedirection(
  double latitude,
  double longitude,
) async {
  // Add your function code here!
  final availableMaps = await map.MapLauncher.installedMaps;
  await availableMaps.first.showDirections(
    destination: map.Coords(latitude, longitude),
  );
}

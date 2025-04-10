// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> sendGetRequestWithParams(
  String origin,
  String destination,
  List<String>? via,
  String apikey,
  String retour,
) async {
  // Add your function code here!
  print('============1');
  String baseUrl = "https://router.hereapi.com/v8/routes";
  List<Map<String, dynamic>> summaries = [];

  // Construction des paramètres de la requête
  Map<String, String> queryParams = {
    'origin': origin,
    'destination': destination,
    'apikey': apikey,
    'return': retour,
    'transportMode': 'car'
  };

  // Construction de l'URI avec les paramètres de requête
  Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

  // Ajout des paramètres 'via'
  if (via != null && via.isNotEmpty) {
    String viaParams = via.map((v) => 'via=$v').join('&');
    uri = Uri.parse('$baseUrl?${uri.query}&$viaParams');
  }

  print('============2');

  // Envoi de la requête GET
  var response = await http.get(uri);

  print('============3');

  // Traitement de la réponse
  if (response.statusCode == 200) {
    // Décoder le corps de la réponse en JSON
    print('============4');
    Map<String, dynamic> jsonResponse = json.decode(response.body);

    // Parcours de chaque route
    for (var route in jsonResponse['routes']) {
      // Parcours de chaque section de la route
      for (var section in route['sections']) {
        // Ajout du résumé de la section à la liste des summaries
        summaries.add(section['summary']);
      }
    }
    print('LA REPONSE $summaries');
    return summaries;
  } else {
    print('============5');
    throw Exception('Erreur lors de la requête : ${response.statusCode}');
  }
}

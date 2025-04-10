import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> formattedCord(List<dynamic>? coordinates) {
  List<String> formattedCoordinates = [];
  if (coordinates != null) {
    formattedCoordinates = coordinates.map((coordinate) {
      return "${coordinate['latitude']},${coordinate['longitude']}";
    }).toList();
  }

  return formattedCoordinates;
}

DateTime? dateReserv(
  String date,
  String time,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // Convertir la date et l'heure en un objet DateTime
  String combined =
      '$date $time'; // Combiner la date et l'heure dans une seule chaîne
  return DateTime.parse(
      combined); // Convertir la chaîne combinée en un objet DateTime
  /// MODIFY CODE ONLY ABOVE THIS LINE
}

List<double> distanceAndDuration(List<dynamic> leTrajet) {
  var totalDistance = 0.0;
  var totalDuration = 0.0;

  for (int i = 0; i < leTrajet.length; i++) {
    totalDuration += leTrajet[i]["duration"];
    totalDistance += leTrajet[i]["length"];
  }
  print('La distance totale $totalDuration');
  print('La duree totale $totalDuration');
  return [totalDistance / 1000, totalDuration];
}

bool isToday(String dateString) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // Convertir la chaîne de caractères en objet DateTime
  DateTime inputDate = DateTime.parse(dateString);

  // Obtenir la date d'aujourd'hui
  DateTime today = DateTime.now();

  // Comparer uniquement les parties année, mois, jour
  return inputDate.year == today.year &&
      inputDate.month == today.month &&
      inputDate.day == today.day;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}

String? transformJsonListToString(List<dynamic>? jsonList) {
  print('LA LISTE $jsonList');

  return jsonList?.map((json) {
    String displayName = json['display_name'].toString();
    String latitude = json['latitude'].toString();
    String longitude = json['longitude'].toString();
    return '($displayName-($latitude)-($longitude))';
  }).join(' ,');
}

String reconv(String leQ) {
  List<int> bytes = latin1.encode(leQ);

  // Re-décoder les bytes en UTF-8
  String correctString = utf8.decode(bytes);

  print(correctString);
  return correctString;
}

String? lePrint() {
  print("========= TEST ========");
  return "";
}

dynamic transforToJson(String q) {
  Map<String, dynamic> res = jsonDecode(q);
  return res;
}

List<int> generatePageListCopy(int count) {
  List<int> pages = [];
  for (int i = 1; i <= count; i++) {
    pages.add(i);
  }
  return pages;
}

String? formatDate(String dateTime) {
  DateTime dateParse = DateTime.parse(dateTime);
// Créer un format spécifique pour la date
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  // Formater la date donnée et retourner la date sans l'heure
  return dateFormat.format(dateParse!);
}

String? formatDateString(String dateStr) {
  List<String> parts =
      dateStr.split('-'); // Divise la chaîne en une liste ["2024", "08", "20"]
  String reversedDate =
      '${parts[2]}-${parts[1]}-${parts[0]}'; // Recompose la chaîne en inversant l'ordre
  return reversedDate;
}

String? formatTimeString(String time) {
  int index = time.indexOf(
      ':', time.indexOf(':') + 1); // Trouve l'index du deuxième `:`
  String trimmedTime = time.substring(0, index); // Prend tout avant ce point
  return trimmedTime;
}

List<String> generatePageList(int count) {
  List<String> pages = [];
  for (int i = 1; i <= count; i++) {
    pages.add('page $i');
  }
  return pages;
}

String? formatDuration(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;

  if (hours > 0) {
    if (minutes > 0 && minutes < 10) {
      return "${hours}H${minutes > 0 ? '0' '$minutes' : ''}";
    } else {
      return "${hours}H${minutes > 0 ? '$minutes' : ''}";
    }
  } else {
    if (minutes > 0 && minutes < 10) {
      return "0${minutes} min";
    } else {
      return "$minutes min";
    }
  }
}

String removeRussianCharacters(String text) {
  // Supprime les caractères russes et les éventuelles virgules et espaces qui suivent
  RegExp regex = RegExp(r'[\u0400-\u04FF]+[\s,]*');

  // Remplace ces caractères par une chaîne vide
  String cleaned = text.replaceAll(regex, '').trim();

  return cleaned;
}

bool doesNotContainRussianCharacters(String text) {
  // Regex pour détecter les caractères cyrilliques (utilisés en russe)
  RegExp russianRegex = RegExp(r'[А-Яа-яЁё]');
  // Retourne true si aucun caractère russe n'est trouvé
  return !russianRegex.hasMatch(text);
}

List<dynamic>? parseAndConvertToJson(String? input) {
  if (input != null && input.isNotEmpty && input != 'null' && input != 'NULL') {
    print("==PAS VIDE== $input");
    // Supprimer les parenthèses de début et de fin
    input = input.substring(1, input.length - 1);

    // Séparer les différentes entrées
    List<String> entries = input.split(') ,(');

    // Liste pour stocker les résultats
    List<Map<String, dynamic>> result = [];

    for (String entry in entries) {
      // Supprimer les parenthèses autour des coordonnées
      //entry = entry.replaceAll('(', '').replaceAll(')', '');

      // Séparer les différentes parties de chaque entrée
      List<String> parts =
          entry.replaceAll('-(', '/').replaceAll(')', '').split('/');

      // Extraire le nom et les coordonnées
      String displayName = parts[0].trim();
      double latitude = double.parse(parts[1].trim());
      double longitude = double.parse(parts[2].trim());

      // Ajouter l'objet à la liste
      result.add({
        'display_name': displayName,
        'longitude': longitude,
        'latitude': latitude
      });
    }

    return result;
  } else {
    print("==VIDE==");
    return null;
  }
}

List<DateTime> startandend(DateTime aktu) {
  DateTime startOfDay = DateTime(aktu.year, aktu.month, aktu.day, 0, 0, 0);

  // Fin du jour actuel (23h59m59s)
  DateTime endOfDay = DateTime(aktu.year, aktu.month, aktu.day, 23, 59, 59);

  return [startOfDay, endOfDay];
}

List<dynamic> listeVide() {
  return [];
}

List<dynamic> combinedList(
  List<dynamic> list1,
  List<dynamic> list2,
) {
  return list1 + list2;
}

String? msgE(int? statusCode) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  switch (statusCode) {
    case 400:
      return 'La requête n’est pas valide.';
    case 401:
      return 'La ressource demandée nécessite une authentification.';
    case 403:
      return 'Autorisations manquantes pour répondre à cette requête.';
    case 404:
      return 'La ressource demandée n’existe pas.';
    case 405:
      return 'La méthode demandée n’est pas autorisée sur la ressource demandée.';
    case 406:
      return 'Format de réponse demandé non pris en charge.';
    case 408:
      return 'La demande a expiré.';
    case 409:
      return 'Le serveur ne peut pas répondre à la requête en raison d’un conflit de serveur.';
    case 410:
      return 'La ressource demandée n’est plus disponible.';
    case 411:
      return 'L’en-tête Content-Length est manquant.';
    case 412:
      return 'Une condition préalable pour cette requête a échoué.';
    case 413:
      return 'La charge utile est trop grande.';
    case 414:
      return 'L’URI est trop long.';
    case 415:
      return 'Le type de média spécifié n’est pas pris en charge.';
    case 416:
      return 'La plage de données demandée ne peut pas être satisfaite.';
    case 417:
      return 'L’en-tête Expect n’a pas pu être satisfait.';
    case 421:
      return 'Impossible de produire une réponse pour cette requête.';
    case 422:
      return 'La requête contient des erreurs sémantiques.';
    case 423:
      return 'La ressource source ou de destination est verrouillée.';
    case 429:
      return 'Trop de requêtes. Réessayez plus tard.';
    case 431:
      return 'Le champ d’en-tête de requête est trop grand.';
    case 500:
      return 'Une erreur générique s’est produite sur le serveur.';
    case 501:
      return 'Le serveur ne prend pas en charge la fonction demandée.';
    case 502:
      return 'Réponse incorrecte reçue d’une autre passerelle.';
    case 503:
      return 'Le serveur est momentanément indisponible. Réessayez ultérieurement.';
    case 504:
      return 'Expiration du délai d’attente d’une autre passerelle.';
    case 507:
      return 'Impossible d’enregistrer les données de la requête.';
    default:
      return 'Erreur inconnue.';
  }

  /// MODIFY CODE ONLY ABOVE THIS LINE
}

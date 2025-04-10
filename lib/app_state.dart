import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _token = prefs.getString('ff_token') ?? _token;
    });

    _safeInit(() {
      _carYear = prefs.getString('ff_carYear') ?? _carYear;
    });
    _safeInit(() {
      _carPlate = prefs.getString('ff_carPlate') ?? _carPlate;
    });
    _safeInit(() {
      _carModel = prefs.getString('ff_carModel') ?? _carModel;
    });
    _safeInit(() {
      _carColor = prefs.getString('ff_carColor') ?? _carColor;
    });

    _safeInit(() {
      _isOnline = prefs.getInt('ff_isOnline') ?? _isOnline;
    });
    _safeInit(() {
      _isAvailable = prefs.getInt('ff_isAvailable') ?? _isAvailable;
    });
    _safeInit(() {
      _statut = prefs.getString('ff_statut') ?? _statut;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_userInfo')) {
        try {
          _userInfo = jsonDecode(prefs.getString('ff_userInfo') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });

    _safeInit(() {
      _cluster = prefs.getStringList('ff_cluster')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _cluster;
    });
    _safeInit(() {
      _leStatus = prefs.getStringList('ff_leStatus')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _leStatus;
    });
    _safeInit(() {
      _leBool = prefs.getStringList('ff_leBool')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _leBool;
    });
    _safeInit(() {
      _moyenPaiement = prefs.getString('ff_moyenPaiement') ?? _moyenPaiement;
    });
    _safeInit(() {
      _status = prefs.getStringList('ff_status')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _status;
    });
    _safeInit(() {
      _otherDriverBol =
          prefs.getStringList('ff_otherDriverBol')?.map(int.parse).toList() ??
              _otherDriverBol;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_baseAdress')) {
        try {
          _baseAdress = jsonDecode(prefs.getString('ff_baseAdress') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _userPosition =
          latLngFromString(prefs.getString('ff_userPosition')) ?? _userPosition;
    });

    _safeInit(() {
      _appVersion = prefs.getString('ff_appVersion') ?? _appVersion;
    });

    _safeInit(() {
      _typeTrans = prefs.getStringList('ff_typeTrans')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _typeTrans;
    });

    _safeInit(() {
      if (prefs.containsKey('ff_userPositionData')) {
        try {
          _userPositionData =
              jsonDecode(prefs.getString('ff_userPositionData') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _cherche = prefs.getBool('ff_cherche') ?? _cherche;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _appVersion = '2.0.4';
  String get appVersion => _appVersion;
  set appVersion(String value) {
    _appVersion = value;
    prefs.setString('ff_appVersion', value);
  }

  Color _couleurChoisie = Color(4285489647);
  Color get couleurChoisie => _couleurChoisie;
  set couleurChoisie(Color value) {
    _couleurChoisie = value;
  }

  String _token = '';
  String get token => _token;
  set token(String value) {
    _token = value;
    prefs.setString('ff_token', value);
  }

  bool _cherche = true;
  bool get cherche => _cherche;
  set cherche(bool value) {
    _cherche = value;
    prefs.setBool('ff_cherche', value);
  }

  List<dynamic> _cluster = [];
  List<dynamic> get cluster => _cluster;
  set cluster(List<dynamic> value) {
    _cluster = value;
    prefs.setStringList('ff_cluster', value.map((x) => jsonEncode(x)).toList());
  }

  void addToCluster(dynamic value) {
    cluster.add(value);
    prefs.setStringList(
        'ff_cluster', _cluster.map((x) => jsonEncode(x)).toList());
  }

  void removeFromCluster(dynamic value) {
    cluster.remove(value);
    prefs.setStringList(
        'ff_cluster', _cluster.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromCluster(int index) {
    cluster.removeAt(index);
    prefs.setStringList(
        'ff_cluster', _cluster.map((x) => jsonEncode(x)).toList());
  }

  void updateClusterAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    cluster[index] = updateFn(_cluster[index]);
    prefs.setStringList(
        'ff_cluster', _cluster.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInCluster(int index, dynamic value) {
    cluster.insert(index, value);
    prefs.setStringList(
        'ff_cluster', _cluster.map((x) => jsonEncode(x)).toList());
  }

  String _carYear = '';
  String get carYear => _carYear;
  set carYear(String value) {
    _carYear = value;
    prefs.setString('ff_carYear', value);
  }

  String _carColor = '';
  String get carColor => _carColor;
  set carColor(String value) {
    _carColor = value;
    prefs.setString('ff_carColor', value);
  }

  String _carModel = '';
  String get carModel => _carModel;
  set carModel(String value) {
    _carModel = value;
    prefs.setString('ff_carModel', value);
  }

  String _carPlate = '';
  String get carPlate => _carPlate;
  set carPlate(String value) {
    _carPlate = value;
    prefs.setString('ff_carPlate', value);
  }

  String _choixImage =
      'https://firebasestorage.googleapis.com/v0/b/gobabiuser.appspot.com/o/imagesCar%2FGOBABI%20CARS-13.png?alt=media&token=4663f6dd-0503-428e-9508-21f949d78563';
  String get choixImage => _choixImage;
  set choixImage(String value) {
    _choixImage = value;
  }

  String _choixCouleur = '#ffffff';
  String get choixCouleur => _choixCouleur;
  set choixCouleur(String value) {
    _choixCouleur = value;
  }

  String _statut = 'active';
  String get statut => _statut;
  set statut(String value) {
    _statut = value;
  }

  int _isOnline = 1;
  int get isOnline => _isOnline;
  set isOnline(int value) {
    _isOnline = value;
    prefs.setInt('ff_isOnline', value);
  }

  int _isAvailable = 1;
  int get isAvailable => _isAvailable;
  set isAvailable(int value) {
    _isAvailable = value;
    prefs.setInt('ff_isAvailable', value);
  }

  dynamic _userInfo;
  dynamic get userInfo => _userInfo;
  set userInfo(dynamic value) {
    _userInfo = value;
    prefs.setString('ff_userInfo', jsonEncode(value));
  }

  List<dynamic> _leStatus = [
    jsonDecode('{\"statutEng\":\"accepted\"}'),
    jsonDecode('{\"statutEng\":\"arriving\"}'),
    jsonDecode('{\"statutEng\":\"arrived\"}'),
    jsonDecode('{\"statutEng\":\"in_progress\"}'),
    jsonDecode('{\"statutEng\":\"completed\"}'),
    jsonDecode('{\"statutEng\":\"canceled\"}')
  ];
  List<dynamic> get leStatus => _leStatus;
  set leStatus(List<dynamic> value) {
    _leStatus = value;
    prefs.setStringList(
        'ff_leStatus', value.map((x) => jsonEncode(x)).toList());
  }

  void addToLeStatus(dynamic value) {
    leStatus.add(value);
    prefs.setStringList(
        'ff_leStatus', _leStatus.map((x) => jsonEncode(x)).toList());
  }

  void removeFromLeStatus(dynamic value) {
    leStatus.remove(value);
    prefs.setStringList(
        'ff_leStatus', _leStatus.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromLeStatus(int index) {
    leStatus.removeAt(index);
    prefs.setStringList(
        'ff_leStatus', _leStatus.map((x) => jsonEncode(x)).toList());
  }

  void updateLeStatusAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    leStatus[index] = updateFn(_leStatus[index]);
    prefs.setStringList(
        'ff_leStatus', _leStatus.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInLeStatus(int index, dynamic value) {
    leStatus.insert(index, value);
    prefs.setStringList(
        'ff_leStatus', _leStatus.map((x) => jsonEncode(x)).toList());
  }

  List<dynamic> _leBool = [
    jsonDecode('{\"bol\":0}'),
    jsonDecode('{\"bol\":1}')
  ];
  List<dynamic> get leBool => _leBool;
  set leBool(List<dynamic> value) {
    _leBool = value;
    prefs.setStringList('ff_leBool', value.map((x) => jsonEncode(x)).toList());
  }

  void addToLeBool(dynamic value) {
    leBool.add(value);
    prefs.setStringList(
        'ff_leBool', _leBool.map((x) => jsonEncode(x)).toList());
  }

  void removeFromLeBool(dynamic value) {
    leBool.remove(value);
    prefs.setStringList(
        'ff_leBool', _leBool.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromLeBool(int index) {
    leBool.removeAt(index);
    prefs.setStringList(
        'ff_leBool', _leBool.map((x) => jsonEncode(x)).toList());
  }

  void updateLeBoolAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    leBool[index] = updateFn(_leBool[index]);
    prefs.setStringList(
        'ff_leBool', _leBool.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInLeBool(int index, dynamic value) {
    leBool.insert(index, value);
    prefs.setStringList(
        'ff_leBool', _leBool.map((x) => jsonEncode(x)).toList());
  }

  String _moyenPaiement = 'cash';
  String get moyenPaiement => _moyenPaiement;
  set moyenPaiement(String value) {
    _moyenPaiement = value;
    prefs.setString('ff_moyenPaiement', value);
  }

  dynamic _otherRider;
  dynamic get otherRider => _otherRider;
  set otherRider(dynamic value) {
    _otherRider = value;
  }

  List<dynamic> _status = [
    jsonDecode('{\"statusEng\":\"accepted\",\"statusFr\":\"accepté\"}'),
    jsonDecode('{\"statusEng\":\"arriving\",\"statusFr\":\"en route\"}'),
    jsonDecode('{\"statusEng\":\"arrived\",\"statusFr\":\"en arrivé\"}'),
    jsonDecode('{\"statusEng\":\"in_progress\",\"statusFr\":\"en cours\"}'),
    jsonDecode('{\"statusEng\":\"completed\",\"statusFr\":\"terminé\"}'),
    jsonDecode('{\"statusEng\":\"canceled\",\"statusFr\":\"annulé\"}'),
    jsonDecode(
        '{\"statusEng\":\"new_ride_requested\",\"statusFr\":\"nouveau\"}')
  ];
  List<dynamic> get status => _status;
  set status(List<dynamic> value) {
    _status = value;
    prefs.setStringList('ff_status', value.map((x) => jsonEncode(x)).toList());
  }

  void addToStatus(dynamic value) {
    status.add(value);
    prefs.setStringList(
        'ff_status', _status.map((x) => jsonEncode(x)).toList());
  }

  //////
  ///
  List<dynamic> _messagesErreur = [
    jsonDecode(
        '{\"code\":\"400\",\"message\":\"La requête n’est pas valide.\"}'),
    jsonDecode(
        '{\"code\":\"401\",\"message\":\"La ressource demandée nécessite une authentification\"}'),
    jsonDecode(
        '{\"code\":\"403\",\"message\":\"Autorisations manquantes pour répondre à cette requête.\"}'),
    jsonDecode(
        '{\"code\":\"404\",\"message\":\"La ressource demandée n’existe pas.\"}'),
    jsonDecode(
        '{\"code\":\"405\",\"message\":\"La méthode demandée n’est pas autorisée sur la ressource demandée.\"}'),
    jsonDecode(
        '{\"code\":\"406\",\"message\":\"Format de réponse demandé non pris en charge.\"}'),
    jsonDecode('{\"code\":\"408\",\"message\":\"La demande a expiré.\"}'),
    jsonDecode(
        '{\"code\":\"409\",\"message\":\"Le serveur ne peut pas répondre à la requête en raison d’un conflit de serveur.\"}'),
    jsonDecode(
        '{\"code\":\"410\",\"message\":\"La ressource demandée n’est plus disponible.\"}'),
    jsonDecode(
        '{\"code\":\"411\",\"message\":\"L’en-tête Content-Length est manquant.\"}'),
    jsonDecode(
        '{\"code\":\"412\",\"message\":\"Une condition préalable pour cette requête a échoué.\"}'),
    jsonDecode(
        '{\"code\":\"413\",\"message\":\"La charge utile est trop grande.\"}'),
    jsonDecode('{\"code\":\"414\",\"message\":\"L’URI est trop long.\"}'),
    jsonDecode(
        '{\"code\":\"415\",\"message\":\"Le type de média spécifié n’est pas pris en charge.\"}'),
    jsonDecode(
        '{\"code\":\"416\",\"message\":\"La plage de données demandée ne peut pas être satisfaite.\"}'),
    jsonDecode(
        '{\"code\":\"417\",\"message\":\"L’en-tête Expect n’a pas pu être satisfait.\"}'),
    jsonDecode(
        '{\"code\":\"421\",\"message\":\"Impossible de produire une réponse pour cette requête.\"}'),
    jsonDecode(
        '{\"code\":\"422\",\"message\":\"La requête contient des erreurs sémantiques.\"}'),
    jsonDecode(
        '{\"code\":\"423\",\"message\":\"La ressource source ou de destination est verrouillée.\"}'),
    jsonDecode(
        '{\"code\":\"429\",\"message\":\"Trop de requêtes. Réessayez plus tard.\"}'),
    jsonDecode(
        '{\"code\":\"431\",\"message\":\"Le champ d’en-tête de requête est trop grand.\"}'),
    jsonDecode(
        '{\"code\":\"500\",\"message\":\"Une erreur générique s’est produite sur le serveur.\"}'),
    jsonDecode(
        '{\"code\":\"501\",\"message\":\"Le serveur ne prend pas en charge la fonction demandée.\"}'),
    jsonDecode(
        '{\"code\":\"502\",\"message\":\"Réponse incorrecte reçue d’une autre passerelle.\"}'),
    jsonDecode(
        '{\"code\":\"503\",\"message\":\"Le serveur est momentanément indisponible. Réessayez ultérieurement.\"}'),
    jsonDecode(
        '{\"code\":\"504\",\"message\":\"Expiration du délai d’attente d’une autre passerelle.\"}'),
    jsonDecode(
        '{\"code\":\"507\",\"message\":\"Impossible d’enregistrer les données de la requête.\"}'),
  ];
  List<dynamic> get messagesErreur => _messagesErreur;
  set messagesErreur(List<dynamic> value) {
    _messagesErreur = value;
    prefs.setStringList(
        'ff_messagesErreur', value.map((x) => jsonEncode(x)).toList());
  }

  void addTomessagesErreur(dynamic value) {
    messagesErreur.add(value);
    prefs.setStringList('ff_messagesErreur',
        _messagesErreur.map((x) => jsonEncode(x)).toList());
  }

/////
  ///
  ///
  ///

  void removeFromStatus(dynamic value) {
    status.remove(value);
    prefs.setStringList(
        'ff_status', _status.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromStatus(int index) {
    status.removeAt(index);
    prefs.setStringList(
        'ff_status', _status.map((x) => jsonEncode(x)).toList());
  }

  void updateStatusAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    status[index] = updateFn(_status[index]);
    prefs.setStringList(
        'ff_status', _status.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInStatus(int index, dynamic value) {
    status.insert(index, value);
    prefs.setStringList(
        'ff_status', _status.map((x) => jsonEncode(x)).toList());
  }

  List<int> _otherDriverBol = [0, 1];
  List<int> get otherDriverBol => _otherDriverBol;
  set otherDriverBol(List<int> value) {
    _otherDriverBol = value;
    prefs.setStringList(
        'ff_otherDriverBol', value.map((x) => x.toString()).toList());
  }

  void addToOtherDriverBol(int value) {
    otherDriverBol.add(value);
    prefs.setStringList(
        'ff_otherDriverBol', _otherDriverBol.map((x) => x.toString()).toList());
  }

  void removeFromOtherDriverBol(int value) {
    otherDriverBol.remove(value);
    prefs.setStringList(
        'ff_otherDriverBol', _otherDriverBol.map((x) => x.toString()).toList());
  }

  void removeAtIndexFromOtherDriverBol(int index) {
    otherDriverBol.removeAt(index);
    prefs.setStringList(
        'ff_otherDriverBol', _otherDriverBol.map((x) => x.toString()).toList());
  }

  void updateOtherDriverBolAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    otherDriverBol[index] = updateFn(_otherDriverBol[index]);
    prefs.setStringList(
        'ff_otherDriverBol', _otherDriverBol.map((x) => x.toString()).toList());
  }

  void insertAtIndexInOtherDriverBol(int index, int value) {
    otherDriverBol.insert(index, value);
    prefs.setStringList(
        'ff_otherDriverBol', _otherDriverBol.map((x) => x.toString()).toList());
  }

  dynamic _baseAdress = jsonDecode(
      '{\"display_name\":\"GoBabi\",\"latitude\":\"5.3975167\",\"longitude\":\"-3.9452607\"}');
  dynamic get baseAdress => _baseAdress;
  set baseAdress(dynamic value) {
    _baseAdress = value;
    prefs.setString('ff_baseAdress', jsonEncode(value));
  }

  LatLng? _userPosition;
  LatLng? get userPosition => _userPosition;
  set userPosition(LatLng? value) {
    _userPosition = value;
    value != null
        ? prefs.setString('ff_userPosition', value.serialize())
        : prefs.remove('ff_userPosition');
  }

  dynamic _userPositionData;
  dynamic get userPositionData => _userPositionData;
  set userPositionData(dynamic value) {
    _userPositionData = value;
    prefs.setString('ff_userPositionData', jsonEncode(value));
  }

  String _playerId = '';
  String get playerId => _playerId;
  set playerId(String value) {
    _playerId = value;
  }

  List<dynamic> _typeTrans = [
    jsonDecode('{\"type\":\"debit\"}'),
    jsonDecode('{\"type\":\"credit\"}')
  ];
  List<dynamic> get typeTrans => _typeTrans;
  set typeTrans(List<dynamic> value) {
    _typeTrans = value;
    prefs.setStringList(
        'ff_typeTrans', value.map((x) => jsonEncode(x)).toList());
  }

  void addToTypeTrans(dynamic value) {
    typeTrans.add(value);
    prefs.setStringList(
        'ff_typeTrans', _typeTrans.map((x) => jsonEncode(x)).toList());
  }

  void removeFromTypeTrans(dynamic value) {
    typeTrans.remove(value);
    prefs.setStringList(
        'ff_typeTrans', _typeTrans.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromTypeTrans(int index) {
    typeTrans.removeAt(index);
    prefs.setStringList(
        'ff_typeTrans', _typeTrans.map((x) => jsonEncode(x)).toList());
  }

  void updateTypeTransAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    typeTrans[index] = updateFn(_typeTrans[index]);
    prefs.setStringList(
        'ff_typeTrans', _typeTrans.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInTypeTrans(int index, dynamic value) {
    typeTrans.insert(index, value);
    prefs.setStringList(
        'ff_typeTrans', _typeTrans.map((x) => jsonEncode(x)).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

Color? _colorFromIntValue(int? val) {
  if (val == null) {
    return null;
  }
  return Color(val);
}

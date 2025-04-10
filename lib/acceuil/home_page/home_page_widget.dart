import 'dart:async';
import 'dart:isolate';
// import 'dart:js_interop';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:app_to_foreground/app_to_foreground.dart';
import 'package:bg_launcher/bg_launcher.dart';

import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as localNot;
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:go_babi_drive/backend/schema/reservations_record.dart';
import 'package:go_babi_drive/composants/new_version/new_version_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gflutter;
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/core.errors.dart';
// import 'package:here_sdk/gestures.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:here_sdk/search.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/composants/drawer_component/drawer_component_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';
import 'package:linear_timer/linear_timer.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/custom_code/actions/index.dart' as actions;
import 'package:badges/badges.dart' as badges;

import 'package:location/location.dart' as loc;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:web_socket_channel/status.dart' as status;
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'
    as ltln;
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as locAcc;
import 'package:http/http.dart' as http;

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with WidgetsBindingObserver {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<_HomePageWidgetState> _keyScaf =
      GlobalKey<_HomePageWidgetState>();

  int prec = 1;
  final localNot.FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      localNot.FlutterLocalNotificationsPlugin();

  // late SearchEngine _onlineSearchEngine;
  bool useOnlineSearchEngine = true;
  UniqueKey _key = UniqueKey();
  bool chargePosition = false;
  // List<MapMarker> _mapMarkers = [];

  // HereMapController? hereMapCont;
  final FlutterTts flutterTts = FlutterTts();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  loc.Location location = loc.Location();
  late loc.LocationData _currentPosition;
  // Bubble _bubble = new Bubble(showCloseButton: false);

  bool enBackground = false;

  // Completer<gflutter.GoogleMapController> _controller = Completer();
  gflutter.GoogleMapController? _controllerg;
  ltln.LatLng? _currentPositionG;
  gflutter.BitmapDescriptor? _carIcon;
  bool _isMapCreated = false;
  // Utilisation de GlobalKey pour maintenir un état de la carte
  Key _mapKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    // _checkOverlayPermission();
    print("LEtoken==${FFAppState().token}");
    // _getLocationUpdates();
    _getLocationUpdates2();

    // Initialiser le plugin
    const localNot.AndroidInitializationSettings initializationSettingsAndroid =
        localNot.AndroidInitializationSettings('@mipmap/ic_launcher');

    const localNot.InitializationSettings initializationSettings =
        localNot.InitializationSettings(android: initializationSettingsAndroid);

    // flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    // );

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'location_channel_id',
        channelName: 'Location Service',
        channelDescription: 'This service keeps track of your location.',
        channelImportance: NotificationChannelImportance.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );

    // ecouter();

    envoiPosiMysql();

    setState(() {
      chargePosition = true;
    });
    WidgetsBinding.instance.addObserver(this);

    print("==EN LIGNE ${FFAppState().isOnline}");

    // try {
    //   _onlineSearchEngine = SearchEngine();
    // } on InstantiationException {
    //   throw ("Initialization of SearchEngine failed.");
    // }

    _getAddressForCoordinates(FFAppState().userPosition!.latitude,
        FFAppState().userPosition!.longitude);

    _getCurrentLocation();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      print("== check lancement ==");

      await Future.wait([
        Future(() async {
          _model.laRideReq = await ApisGoBabiGroup.currentRideRequestCall.call(
            token: FFAppState().token,
            id: getJsonField(
              FFAppState().userInfo,
              r'''$.id''',
            ).toString().toString(),
          );

          if ((_model.laRideReq?.succeeded ?? true)) {
            _model.rideActuelle = (_model.laRideReq?.jsonBody ?? '');

            if ((ApisGoBabiGroup.currentRideRequestCall.statut(
                      (_model.laRideReq?.jsonBody ?? ''),
                    ) ==
                    'completed') ||
                (ApisGoBabiGroup.currentRideRequestCall.statut(
                      (_model.laRideReq?.jsonBody ?? ''),
                    ) ==
                    'canceled') ||
                (getJsonField(
                      (_model.laRideReq?.jsonBody ?? ''),
                      r'''$.id''',
                    ) ==
                    null)) {
              _model.apiResulti97z =
                  await ApisGoBabiGroup.updateUserConnexionCall.call(
                id: getJsonField(
                  FFAppState().userInfo,
                  r'''$.id''',
                ),
                status: 'active',
                isOnline: 1,
                isAvailable: 1,
                token: FFAppState().token,
              );

              if ((_model.apiResulti97z?.succeeded ?? true)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Vous etes en ligne',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    duration: const Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                  ),
                );
                _model.enLigne = true;
                FFAppState().isOnline = 1;
                FFAppState().statut = 'active';
                FFAppState().isAvailable = 1;
                setState(() {});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Une erreur ${_model.apiResulti97z?.statusCode} est survenue veuillez réessayer',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    duration: const Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).error,
                  ),
                );
                _model.enLigne = false;
                setState(() {});
                setState(() {
                  _model.switchValue = false;
                });
              }
            } else {
              _model.apiResulti97a =
                  await ApisGoBabiGroup.updateUserConnexionCall.call(
                id: getJsonField(
                  FFAppState().userInfo,
                  r'''$.id''',
                ),
                status: 'active',
                isOnline: 1,
                isAvailable: 0,
                token: FFAppState().token,
              );

              if ((_model.apiResulti97a?.succeeded ?? true)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Vous etes indisponible',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    duration: const Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                  ),
                );
                _model.enLigne = true;
                FFAppState().isOnline = 1;
                FFAppState().statut = 'active';
                FFAppState().isAvailable = 0;
                setState(() {});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Une erreur ${_model.apiResulti97a?.statusCode} est survenue veuillez réessayer',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    duration: const Duration(milliseconds: 4000),
                    backgroundColor: FlutterFlowTheme.of(context).error,
                  ),
                );
                _model.enLigne = false;
                setState(() {});
                setState(() {
                  _model.switchValue = false;
                });
              }
            }
            ;

            setState(() {});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Une erreur ride est survenue veuillez reessayer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                duration: const Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).error,
              ),
            );
          }
        }),
        Future(() async {
          setState(() {
            _model.switchValue = (getJsonField(
                      FFAppState().userInfo,
                      r'''$.is_online''',
                    ) ==
                    getJsonField(
                      FFAppState().leBool.first,
                      r'''$.bol''',
                    )
                ? false
                : true);
          });
          _model.enLigne = getJsonField(
                    FFAppState().userInfo,
                    r'''$.is_online''',
                  ) ==
                  getJsonField(
                    FFAppState().leBool.first,
                    r'''$.bol''',
                  )
              ? false
              : true;
          setState(() {});
        }),
        Future(() async {
          _model.apiResultmze = await ApisGoBabiGroup.walletCheckCall.call(
            token: FFAppState().token,
          );

          if (!(_model.apiResultmze?.succeeded ?? true)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Une erreur wallet est survenue veuillez réessayer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                duration: const Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).error,
              ),
            );
          }
        }),
        Future(() async {
          setState(() {
            _model.switchValue = (FFAppState().isOnline == 1 ? true : false);
          });
        }),
        Future(() async {
          _model.apiResulteyo = await StatCoursesMontantCall.call(
            status: 'completed',
            driverId: getJsonField(
              FFAppState().userInfo,
              r'''$.id''',
            ),
            startDate:
                functions.startandend(getCurrentTimestamp).first.toString(),
            endDate: functions.startandend(getCurrentTimestamp).last.toString(),
          );

          if (!(_model.apiResulteyo?.succeeded ?? true)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Une erreur ${_model.apiResulteyo?.statusCode} est survenue , veuillez réessayer',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                duration: const Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).error,
              ),
            );
          }
        }),
        Future(() async {
          _model.apiResultsh1 = await ApisGoBabiGroup.userDetailCall.call(
            userId: getJsonField(
              FFAppState().userInfo,
              r'''$.id''',
            ),
            token: FFAppState().token,
          );

          if ((_model.apiResultsh1?.succeeded ?? true)) {
            FFAppState().carColor = ApisGoBabiGroup.userDetailCall.carColor(
              (_model.apiResultsh1?.jsonBody ?? ''),
            )!;
            FFAppState().carYear = ApisGoBabiGroup.userDetailCall.carProdYear(
              (_model.apiResultsh1?.jsonBody ?? ''),
            )!;
            FFAppState().carPlate =
                ApisGoBabiGroup.userDetailCall.carPlateNumber(
              (_model.apiResultsh1?.jsonBody ?? ''),
            )!;
            FFAppState().carModel = ApisGoBabiGroup.userDetailCall.carModel(
              (_model.apiResultsh1?.jsonBody ?? ''),
            )!;

            print("==== car color ${FFAppState().carColor} ====");
            setState(() {});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Une erreur est survenue',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                duration: const Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).error,
              ),
            );
          }
        }),
        Future(() async {
          _model.apiResultkzc = await ApisGoBabiGroup.zonesPourClusterCall.call(
            token: FFAppState().token,
          );

          if ((_model.apiResultkzc?.succeeded ?? true)) {
            FFAppState().cluster = getJsonField(
              (_model.apiResultkzc?.jsonBody ?? ''),
              r'''$.data''',
              true,
            )!
                .toList()
                .cast<dynamic>();
            setState(() {});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Erreur lors de la requête de cluster veuillez recommencer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                duration: const Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).error,
              ),
            );
          }
        }),

        // Future(() async {
        //   _model.version = await queryAppVersionRecordOnce(
        //     singleRecord: true,
        //   ).then((s) => s.firstOrNull);
        //   if (FFAppState().appVersion != _model.version?.versionDriver) {
        //     await showModalBottomSheet(
        //       isScrollControlled: true,
        //       backgroundColor: Colors.transparent,
        //       isDismissible: false,
        //       enableDrag: false,
        //       context: context,
        //       builder: (context) {
        //         return GestureDetector(
        //           onTap: () => FocusScope.of(context).unfocus(),
        //           child: Padding(
        //             padding: MediaQuery.viewInsetsOf(context),
        //             child: NewVersionWidget(
        //               portable: isAndroid,
        //               laVersion: _model.version?.versionDriver,
        //             ),
        //           ),
        //         );
        //       },
        //     ).then((value) => safeSetState(() {}));
        //   }
        // }),

        Future(() async {
          _model.apiResultnnv = await ApisGoBabiGroup.saveVersionCall.call(
            version: FFAppState().appVersion,
            id: getJsonField(
              FFAppState().userInfo,
              r'''$.id''',
            ),
          );

          if (!(_model.apiResultnnv?.succeeded ?? true)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Erreur lors de l\'enregistrement de la version',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                duration: const Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).secondary,
              ),
            );
          }
        }),
        Future(() async {
          _model.apiResultumj = await ApisGoBabiGroup.saveConnexionCall.call(
            id: getJsonField(
              FFAppState().userInfo,
              r'''$.id''',
            ),
          );

          if ((_model.apiResultumj?.succeeded ?? true)) {
            print("Ok");
          }
        }),
        _getAddressForCoordinates(
            getJsonField(
              FFAppState().userPositionData,
              r'''$.latitude''',
            ),
            getJsonField(
              FFAppState().userPositionData,
              r'''$.longitude''',
            ))
      ]);
    });

    _model.switchValue = false;
  }

  @override
  void dispose() {
    _controllerg?.dispose();
    _model.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  ecouter() async {
    print('===WebSocket 1==');
    final wsUrl = Uri.parse(
        'ws://appgobabi.com:6001/app/local?protocol=7&client=js&version=4.3.0');
    print('===WebSocket 2==');
    final channel = WebSocketChannel.connect(wsUrl);
    print('===WebSocket 3==');
    await channel.ready.then((value) {}).catchError((error) {
      print("Error connecting to WebSocket: $error");
    });
    print('===WebSocket 4==');

    channel.stream.listen(
      (message) {
        print("==message websocket received: $message");
        channel.sink.add('voir');
        // channel.sink.close(status.goingAway);
      },
      onError: (error) {
        print('Erreur WebSocket: $error'); // Gère les erreurs de connexion
      },
    );
  }

  Future<void> speakText(String text) async {
    await flutterTts.setLanguage("fr-fr");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  // Future<void> startBubbleHead() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // We also handle the message potentially returning null.
  //   try {
  //     await _bubble.startBubbleHead(sendAppToBackground: false);
  //   } on PlatformException {
  //     print('Failed to call startBubbleHead');
  //   }
  // }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> stopBubbleHead() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // We also handle the message potentially returning null.
  //   try {
  //     await _bubble.stopBubbleHead();
  //   } on PlatformException {
  //     print('Failed to call stopBubbleHead');
  //   }
  // }

  envoiPosiMysql() async {
    // Start a timer that repeats every 10 seconds
    Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (!mounted) {
        timer.cancel(); // Cancel the timer if the widget is no longer mounted
        return;
      }

      Future(() async {
        _model.resChangePosition =
            await ApisGoBabiGroup.updateUserLocalisationCall.call(
          id: getJsonField(
            FFAppState().userInfo,
            r'''$.id''',
          ),
          token: FFAppState().token,
          latitude: getJsonField(
            FFAppState().userPositionData,
            r'''$.latitude''',
          ).toString().toString(),
          longitude: getJsonField(
            FFAppState().userPositionData,
            r'''$.longitude''',
          ).toString().toString(),
        );

        if ((_model.resChangePosition?.succeeded ?? true)) {
          print("==position succes changement");
          setState(() {});
        } else {
          print(
              "==position erreur changement${_model.resChangePosition?.statusCode} ");
        }
      });
    });
  }

  void _startForegroundTask() async {
    await FlutterForegroundTask.startService(
      notificationTitle: 'Localisation active',
      notificationText: 'Votre position est surveillée.',
      callback: startCallback,
    );
  }

  static void startCallback() {
    FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
  }

  Future<void> showPersistentNotification() async {
    const localNot.AndroidNotificationDetails androidPlatformChannelSpecifics =
        localNot.AndroidNotificationDetails(
      'persistent_channel', // ID du canal
      'Persistent Notifications', // Nom du canal
      importance: localNot.Importance.max,
      priority: localNot.Priority.high,
      ongoing: true,
      autoCancel: false,
      usesChronometer: true,
      styleInformation: localNot.BigTextStyleInformation(''),

      actions: <localNot.AndroidNotificationAction>[
        // Définir des actions pour la notification
        localNot.AndroidNotificationAction(
          'ACCEPT_ACTION',
          'Accepter',
          showsUserInterface: true,
          cancelNotification: false,
        ),
        localNot.AndroidNotificationAction(
          'REJECT_ACTION',
          'Refuser',
          showsUserInterface: true,
          cancelNotification: false,
        ),
      ],

      // Cela rend la notification persistante
    );

    const localNot.NotificationDetails platformChannelSpecifics =
        localNot.NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notification
      'Notification Persistante',
      'Ceci est une notification persistante',
      platformChannelSpecifics,
    );
  }

  void _getLocationUpdates2() {
    geolocator.Geolocator.getPositionStream(
      locationSettings: const geolocator.LocationSettings(
        accuracy: geolocator.LocationAccuracy.best,
        // distanceFilter: 5,
      ),
    ).listen((geolocator.Position position) {
      print(position == null
          ? 'Unknown'
          : '==position' +
              position.latitude.toString() +
              ', ' +
              position.longitude.toString());

      FFAppState().userPositionData = {
        'longitude': position.longitude,
        'latitude': position.latitude
      };

      _updateLocationInFirestore(position.latitude!, position.longitude!);
    });
  }

  void _getLocationUpdates() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("===update location===");
      if (mounted) {
        setState(() {
          _currentPosition = currentLocation;
          FFAppState().userPositionData = {
            'longitude': _currentPosition.longitude,
            'latitude': _currentPosition.latitude
          };
        });

        _updateLocationInFirestore(
            _currentPosition.latitude!, _currentPosition.longitude!);
      }
    });
  }

  Future<void> _updateStatusRiderRequest() async {
    try {
      await firestore
          .collection('users')
          .doc(getJsonField(
            FFAppState().userInfo,
            r'''$.id''',
          ).toString())
          .set({
        'id_request': 0,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating location: $e");
    }
  }

  Future<void> _updateLocationInFirestore(
      double latitude, double longitude) async {
    try {
      print("==posi firestore==  ");
      await firestore
          .collection('users')
          .doc(getJsonField(
            FFAppState().userInfo,
            r'''$.id''',
          ).toString())
          .set({
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),

        // 'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating location: $e");
    }
  }

  Future<void> _updateBackInFirestore(String back) async {
    try {
      print("==back firestore==");
      await firestore
          .collection('users')
          .doc(getJsonField(
            FFAppState().userInfo,
            r'''$.id''',
          ).toString())
          .set({
        'etatappli': back,
        'heureback': FieldValue.serverTimestamp(),

        // 'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating back: $e");
    }
  }

  Future<void> _uodateRemaining() async {
    try {
      await firestore
          .collection('users')
          .doc(getJsonField(
            FFAppState().userInfo,
            r'''$.id''',
          ).toString())
          .set({
        'distanceriderdriverrestant': 0,
        'tempsdriverriderrestant': 0,
        'distancetrajetrestant': 0,
        'tempstrajetrestant': 0,
        // 'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating location: $e");
    }
  }

  // Fonction pour afficher le BottomSheet

  Future<void> saveDocumentToFirebase(driver_id, rider_id, ride_id,
      tempstrajetrestant, distancetrajetrestant) async {
    // Référence à Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // ID personnalisé pour le document
    String documentId = ride_id.toString();

    // Données à enregistrer
    Map<String, dynamic> data = {
      'distanceriderdriverrestant': 0.0,
      'tempsdriverriderrestant': 0,
      'distancetrajetrestant': distancetrajetrestant,
      'tempstrajetrestant': tempstrajetrestant,
      'driver_id': driver_id,
      'rider_id': rider_id,
      'ride_id': ride_id,
    };

    try {
      // Enregistrer le document avec l'ID personnalisé
      await firestore
          .collection('distancetempstrajet')
          .doc(documentId) // Utilise '56789' comme ID du document
          .set(data);

      print("Document enregistré avec succès !");
    } catch (e) {
      print("Erreur lors de l'enregistrement du document: $e");
    }
  }

  Future<void> _checkOverlayPermission() async {
    if (!await Permission.systemAlertWindow.isGranted) {
      await Permission.systemAlertWindow.request();
    }
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
        // await driverStatus(status: 0);
        // print('skollo detached');
        break; // Ajoutez un break ici

      case AppLifecycleState.resumed:
        // stopBubbleHead();
        setState(() {
          enBackground = false;
        });
        _updateBackInFirestore('En premier plan');
        _model.laRideReq2 = await ApisGoBabiGroup.currentRideRequestCall.call(
          token: FFAppState().token,
          id: getJsonField(
            FFAppState().userInfo,
            r'''$.id''',
          ).toString().toString(),
        );

        if ((_model.laRideReq2?.succeeded ?? true)) {
          if ((getJsonField(
                    (_model.laRideReq2?.jsonBody ?? ''),
                    r'''$.status''',
                  ).toString().toString() ==
                  'completed') ||
              (getJsonField(
                    (_model.laRideReq2?.jsonBody ?? ''),
                    r'''$.status''',
                  ).toString().toString() ==
                  'canceled') ||
              (getJsonField(
                    (_model.laRideReq2?.jsonBody ?? ''),
                    r'''$.id''',
                  ) ==
                  null)) {
            try {
              // Récupération du document
              DocumentSnapshot userDoc = await firestore
                  .collection('users')
                  .doc(getJsonField(
                    FFAppState().userInfo,
                    r'''$.id''',
                  ).toString())
                  .get();

              if (userDoc.exists) {
                // Récupération du champ id_request
                var idRequest = userDoc.get('id_request');

                if (idRequest == 0) {
                  print("id_request est égal à 0");
                  // Effectuez des actions si id_request est égal à 0
                  _model.apiResulti97 =
                      await ApisGoBabiGroup.updateUserConnexionCall.call(
                    id: getJsonField(
                      FFAppState().userInfo,
                      r'''$.id''',
                    ),
                    status: 'active',
                    isOnline: 1,
                    isAvailable: 1,
                    token: FFAppState().token,
                  );

                  if ((_model.apiResulti97?.succeeded ?? true)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Vous etes en ligne',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        duration: Duration(milliseconds: 4000),
                        backgroundColor: FlutterFlowTheme.of(context).secondary,
                      ),
                    );
                    _model.enLigne = true;
                    FFAppState().isOnline = 1;
                    FFAppState().statut = 'active';
                    FFAppState().isAvailable = 1;

                    setState(() {
                      _model.switchValue = true;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Une erreur ${_model.apiResulti97?.statusCode} est survenue veuillez réessayer',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        duration: Duration(milliseconds: 4000),
                        backgroundColor: FlutterFlowTheme.of(context).error,
                      ),
                    );
                    _model.enLigne = false;
                    setState(() {});
                    setState(() {
                      _model.switchValue = false;
                    });
                  }
                } else {
                  print("id_request n'est pas égal à 0");
                  // Effectuez des actions si id_request n'est pas égal à 0
                }
              } else {
                print("Le document utilisateur n'existe pas");
              }
            } catch (e) {
              print("Erreur lors de la vérification du champ id_request: $e");
            }
          } else {
            _model.apiResulti97c =
                await ApisGoBabiGroup.updateUserConnexionCall.call(
              id: getJsonField(
                FFAppState().userInfo,
                r'''$.id''',
              ),
              status: 'active',
              isOnline: 1,
              isAvailable: 0,
              token: FFAppState().token,
            );

            if ((_model.apiResulti97c?.succeeded ?? true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Vous etes indisponible',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
              );
              _model.enLigne = true;
              FFAppState().isOnline = 1;
              FFAppState().statut = 'active';
              FFAppState().isAvailable = 0;
              setState(() {});
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Une erreur ${_model.apiResulti97c?.statusCode} est survenue veuillez réessayer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: FlutterFlowTheme.of(context).error,
                ),
              );
              _model.enLigne = false;
              setState(() {});
              setState(() {
                _model.switchValue = false;
              });
            }
          }
        }
        ;
        await getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0))
            .then((value) => {
                  _getAddressForCoordinates(value.latitude, value.longitude),
                  _updateLocationInFirestore(value.latitude!, value.longitude!)
                });
        setState(() {
          _mapKey =
              UniqueKey(); // 👉 change la clé pour forcer une reconstruction
          _controllerg = null;
        });
        // _moveCameraIfValid();
        print('skollo resumed $enBackground');
        break; // Ajoutez un break ici

      case AppLifecycleState.inactive:
        print('skollo inactive');
        // startBubbleHead();
        break; // Ajoutez un break ici

      case AppLifecycleState.hidden:
        setState(() {
          enBackground = true;
        });
        print('skollo hidden $enBackground');

        break; // Ajoutez un break ici

      case AppLifecycleState.paused:
        setState(() {
          enBackground = true;
        });
        print('skollo paused $enBackground');
        _updateBackInFirestore('En arrière plan');

        _getLocationUpdates2();
        startCallback();
        break; // Ajoutez un break ici

      case AppLifecycleState.detached:
        print('detached');
    }

    final isBackground = state == AppLifecycleState.detached;

    // if (isBackground) {
    //   print("mm");
    //   final response = await http.get(Uri.parse(
    //       'http://api.test/connexion.php?contact_number=2250709600582'));

    //   // service.stop();
    // } else {
    //   // service.start();
    // }
  }

  void _sendBroadcastIntent() {
    print("=====BROADCOAST======");
    final AndroidIntent intent = AndroidIntent(
      action: 'com.gobabidrive.NOTIFICATION_ACTION',
    );
    intent.sendBroadcast();
    print("=====BROADCOAST======");
  }

  // void _addMapMarker(HereMapController _hereMapController,
  //     GeoCoordinates geoCoordinates, String image) {
  //   int imageWidth = 130;
  //   int imageHeight = 130;
  //   MapImage mapImage =
  //       MapImage.withFilePathAndWidthAndHeight(image, imageWidth, imageHeight);
  //   MapMarker mapMarker = MapMarker(geoCoordinates, mapImage);
  //   _hereMapController.mapScene.addMapMarker(mapMarker);
  //   _mapMarkers.add(mapMarker);
  // }

  // MapPolygon _createMapCircle(GeoCoordinates coord, Color color) {
  //   print("==LES ZONES CERCLES");
  //   double radiusInMeters = 2000;
  //   GeoCircle geoCircle = GeoCircle(coord, radiusInMeters);

  //   GeoPolygon geoPolygon = GeoPolygon.withGeoCircle(geoCircle);
  //   // Color fillColor = Color.fromARGB(160, 0, 144, 138);
  //   MapPolygon mapPolygon = MapPolygon(geoPolygon, color);

  //   return mapPolygon;
  // }

  _gereAjoutZoneCommandes() {
    List<Color> colors = [
      const Color.fromARGB(92, 244, 67, 54),
      const Color.fromARGB(66, 255, 153, 0),
      Color.fromARGB(66, 255, 235, 59),
    ];
    List<dynamic> zonesCommandes = FFAppState().cluster;
    print("les zones $zonesCommandes");
    for (int i = 0; i < zonesCommandes.length; i++) {
      List<String> latLongSplit = zonesCommandes[i]['latlong'].split(',');
      // Convertir les valeurs en double
      double latitude = double.parse(latLongSplit[0]);
      double longitude = double.parse(latLongSplit[1]);

      // hereMapCont!.mapScene.addMapPolygon(
      //     _createMapCircle(GeoCoordinates(latitude, longitude), colors[i]));
    }
  }

  // void _onMapCreated(HereMapController hereMapController) {
  //   print("LA MAP");
  //   hereMapCont = hereMapController;
  //   hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
  //       (MapError? error) {
  //     if (error != null) {
  //       print('Map scene not loaded. MapError: ${error.toString()}');
  //       return;
  //     }

  //     const double distanceToEarthInMeters = 3000;
  //     MapMeasure mapMeasureZoom =
  //         MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
  //     hereMapController.camera.lookAtPointWithMeasure(
  //         GeoCoordinates(
  //             getJsonField(
  //               FFAppState().userPositionData,
  //               r'''$.latitude''',
  //             ),
  //             getJsonField(
  //               FFAppState().userPositionData,
  //               r'''$.longitude''',
  //             )),
  //         mapMeasureZoom);
  //   });

  //   hereMapController.mapScene.enableFeatures(
  //       {MapFeatures.trafficFlow: MapFeatureModes.trafficFlowWithFreeFlow});

  //   // _cameraStateListener(hereMapController);

  //   _gereAjoutZoneCommandes();
  //   _addMapMarker(
  //       hereMapController,
  //       GeoCoordinates(
  //           getJsonField(
  //             FFAppState().userPositionData,
  //             r'''$.latitude''',
  //           ),
  //           getJsonField(
  //             FFAppState().userPositionData,
  //             r'''$.longitude''',
  //           )),
  //       'assets/images/ic_car.png');
  // }

  // void _cameraStateListener(HereMapController _hereMapController) {
  //   _hereMapController.gestures.panListener = PanListener(
  //       (GestureState gestureState, Point2D ledeuxd, Point2D ledeux,
  //           double doub) {
  //     if (gestureState == GestureState.begin) {
  //       // Get the coordinates at the center of the map
  //       GeoCoordinates centerCoordinates =
  //           _hereMapController.camera.state.targetCoordinates;
  //       print(
  //           'Center coordinates: ${centerCoordinates.latitude}, ${centerCoordinates.longitude}');
  //     }
  //     if (gestureState == GestureState.end) {
  //       GeoCoordinates centerCoordinates =
  //           _hereMapController.camera.state.targetCoordinates;
  //       print(
  //           'Center coordinates: ${centerCoordinates.latitude}, ${centerCoordinates.longitude}');
  //       _getAddressForCoordinates(centerCoordinates);
  //     }
  //   });
  // }

  Future<void> _getAddressForCoordinates(
      double latitude, double longitude) async {
    // URL de l'API avec les paramètres
    final url = Uri.parse(
        'https://revgeocode.search.hereapi.com/v1/revgeocode?at=$latitude,$longitude&limit=1&lang=fr-FR&apiKey=EvTffyyGJgaLRJ0AcT1Ecqx5KzGJ36PTmcVZEBzVI2Y');

    try {
      // Envoi de la requête GET
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Si la réponse est un succès (200 OK)
        // Décodage de la réponse JSON
        var data = jsonDecode(response.body);
        print(
            "===la data : ${data['items']!.first['title']}"); // Affiche la réponse JSON dans la console
        setState(() {
          _model.choixMap = {
            "title": data['items']!.first['title'],
            "display_name": data['items']!.first['title'],
            "latitude": data['items']!.first['position']['lat'],
            "longitude": data['items']!.first['position']['lng']
          };
          chargePosition = false;
        });
        FFAppState().userPositionData = _model.choixMap;
      } else {
        // Si la requête échoue
        print(
            'Erreur lors de la récupération des données : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur : $e');
    }
  }

  // void _clearRouteAndMarkers(HereMapController hereMapController) {
  //   for (var mapMarker in _mapMarkers) {
  //     hereMapController.mapScene.removeMapMarker(mapMarker);
  //   }
  //   _mapMarkers.clear();
  // }

  // void _handleReverseGeocodingResults(
  //     SearchError? searchError, List<Place>? list) {
  //   if (searchError != null) {
  //     print("Reverse geocoding Error: " + searchError.toString());
  //     return;
  //   }

  //   // If error is null, list is guaranteed to be not empty.
  //   setState(() {
  //     _model.choixMap = {
  //       "title": list!.first?.address.addressText.split(',')[0],
  //       "display_name": list!.first?.address.addressText,
  //       "latitude": list!.first?.geoCoordinates?.latitude,
  //       "longitude": list!.first?.geoCoordinates?.longitude
  //     };
  //     chargePosition = false;
  //   });
  //   FFAppState().userPositionData = _model.choixMap;
  //   if (list != null) {
  //     print("Reverse geocoded address:" + list.first.address.addressText);
  //   }

  //   // if (hereMapCont != null) {
  //   //   _clearRouteAndMarkers(hereMapCont!);
  //   //   _onMapCreated(hereMapCont!);
  //   // }
  // }

  Future<void> _loadCarIcon() async {
    _carIcon = await gflutter.BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(10, 10)),
      'assets/images/ic_car.png',
    );
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: locAcc.LocationAccuracy.high);

    setState(() {
      _currentPositionG = ltln.LatLng(position.latitude, position.longitude);
    });

    // final controller = await _controller.future;
  }

  void _moveCameraIfValid() {
    if (_controllerg != null) {
      print("==il est la==");
      _controllerg?.animateCamera(
          gflutter.CameraUpdate.newLatLngZoom(_currentPositionG!, 17));
    } else {
      print("==il n est pas la==");
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return PopScope(
      canPop: true,
      child: GestureDetector(
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          drawer: Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            child: Drawer(
              elevation: 16.0,
              child: Stack(
                children: [
                  wrapWithModel(
                    model: _model.drawerComponentModel,
                    updateCallback: () => setState(() {}),
                    child: const DrawerComponentWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 20.0, 30.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 20.0,
                          borderWidth: 1.0,
                          buttonSize: 40.0,
                          fillColor: const Color(0xFF754CE3),
                          icon: const Icon(
                            Icons.menu_open_rounded,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            if (scaffoldKey.currentState!.isDrawerOpen ||
                                scaffoldKey.currentState!.isEndDrawerOpen) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlutterFlowIconButton(
                  // borderColor: FlutterFlowTheme.of(context).primary,
                  borderRadius: 20,
                  borderWidth: 0,
                  buttonSize: 40,
                  icon: Icon(
                    Icons.menu_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24,
                  ),
                  onPressed: () async {
                    scaffoldKey.currentState!.openDrawer();
                  },
                ),
                InkWell(
                  onTap: () async {
                    print("== SHOW ==");
                    await _getAddressForCoordinates(
                        getJsonField(
                          _model.choixMap,
                          r'''$.latitude''',
                        ),
                        getJsonField(
                          _model.choixMap,
                          r'''$.longitude''',
                        )).then((value) => {
                          toast(getJsonField(
                            _model.choixMap,
                            r'''$.display_name''',
                          ))
                        });
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.brightness_1_sharp,
                            color: _model.enLigne
                                ? FlutterFlowTheme.of(context).secondary
                                : FlutterFlowTheme.of(context).secondaryText,
                            size: 14.0,
                          ),
                          Text(
                            _model.enLigne ? 'En ligne' : 'Hors ligne',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: _model.enLigne
                                      ? FlutterFlowTheme.of(context).secondary
                                      : FlutterFlowTheme.of(context)
                                          .secondaryText,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ].divide(const SizedBox(width: 3.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Color.fromARGB(255, 88, 0, 104),
                            size: 10,
                          ),
                          chargePosition
                              ? Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 152, 152, 152),
                                  highlightColor:
                                      const Color.fromARGB(255, 232, 232, 232),
                                  child: const Text(
                                    'Position ...',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                )
                              : Text(
                                  'Ma position',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: const Color(0xFF8B97A0),
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),

                          // Text(getJsonField(
                          //     _model.choixMap,
                          //     r'''$.display_name''',
                          //   ).toString())
                        ],
                      )
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _model.switchValue!,
                  onChanged: (newValue) async {
                    setState(() => _model.switchValue = newValue!);
                    if (newValue!) {
                      _model.apiResulti97e =
                          await ApisGoBabiGroup.updateUserConnexionCall.call(
                        id: getJsonField(
                          FFAppState().userInfo,
                          r'''$.id''',
                        ),
                        status: 'active',
                        isOnline: 1,
                        isAvailable: 1,
                        token: FFAppState().token,
                      );

                      if ((_model.apiResulti97e?.succeeded ?? true)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Vous etes en ligne',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            duration: const Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                          ),
                        );
                        _model.enLigne = true;
                        FFAppState().isOnline = 1;
                        FFAppState().statut = 'active';
                        FFAppState().isAvailable = 1;
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Une erreur ${_model.apiResulti97e?.statusCode} est survenue veuillez réessayer',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            duration: const Duration(milliseconds: 4000),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                        _model.enLigne = false;
                        setState(() {});
                        setState(() {
                          _model.switchValue = false;
                        });
                      }

                      setState(() {});
                    } else {
                      _model.apiResulti97Copy =
                          await ApisGoBabiGroup.updateUserConnexionCall.call(
                        id: getJsonField(
                          FFAppState().userInfo,
                          r'''$.id''',
                        ),
                        status: 'inactive',
                        isOnline: 0,
                        isAvailable: 0,
                        token: FFAppState().token,
                      );

                      if ((_model.apiResulti97Copy?.succeeded ?? true)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Vous etes hors ligne',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            duration: const Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                          ),
                        );
                        _model.enLigne = false;
                        FFAppState().isAvailable = 0;
                        FFAppState().statut = 'inactive';
                        FFAppState().isOnline = 0;
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Une erreur ${_model.apiResulti97?.statusCode} est survenue veuillez réessayer',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            duration: const Duration(milliseconds: 4000),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                        _model.enLigne = true;
                        setState(() {});
                        setState(() {
                          _model.switchValue = true;
                        });
                      }

                      setState(() {});
                    }
                  },
                  activeColor: FlutterFlowTheme.of(context).secondary,
                  activeTrackColor: FlutterFlowTheme.of(context).secondary,
                  inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
                  inactiveThumbColor:
                      FlutterFlowTheme.of(context).secondaryText,
                ),
              ],
            ),
            actions: [],
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: StreamBuilder<List<UsersRecord>>(
              stream: queryUsersRecord(
                queryBuilder: (usersRecord) => usersRecord.where(
                  'id',
                  isEqualTo: int.parse(getJsonField(
                    FFAppState()?.userInfo,
                    r'''$.id''',
                  ).toString()),
                ),
                singleRecord: true,
              )..listen((snapshot) {
                  List<UsersRecord> stackUsersRecordList = snapshot;
                  final stackUsersRecord = stackUsersRecordList.isNotEmpty
                      ? stackUsersRecordList.first
                      : null;
                  if (_model.stackPreviousSnapshot != null &&
                      !const ListEquality(UsersRecordDocumentEquality()).equals(
                          stackUsersRecordList, _model.stackPreviousSnapshot)) {
                    () async {
                      if (stackUsersRecord?.idRequest != 0 &&
                          _model.stackPreviousSnapshot?.first.idRequest !=
                              stackUsersRecord?.idRequest) {
                        print(
                            "==NEWS== ${_model.stackPreviousSnapshot?.first.idRequest}");
                        if (enBackground == true) {
                          AppToForeground.appToForeground();
                        }

                        _model.apiResulti97d =
                            await ApisGoBabiGroup.updateUserConnexionCall.call(
                          id: getJsonField(
                            FFAppState().userInfo,
                            r'''$.id''',
                          ),
                          status: 'active',
                          isOnline: 1,
                          isAvailable: 0,
                          token: FFAppState().token,
                        );

                        if ((_model.apiResulti97d?.succeeded ?? true)) {
                          print("check course");
                          _model.enLigne = true;
                          FFAppState().isOnline = 1;
                          FFAppState().statut = 'active';
                          FFAppState().isAvailable = 0;
                          if (mounted) {
                            setState(() {});
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Une erreur ${_model.apiResulti97c?.statusCode} est survenue veuillez réessayer',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              duration: const Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).error,
                            ),
                          );
                          _model.enLigne = false;
                          if (mounted) {
                            setState(() {
                              _model.switchValue = false;
                            });
                          }
                          // setState(() {});
                        }

                        _model.soundPlayer ??= AudioPlayer();
                        if (_model.soundPlayer!.playing) {
                          await _model.soundPlayer!.stop();
                        }
                        _model.soundPlayer!.setVolume(1.0);
                        _model.soundPlayer!
                            .setAsset('assets/audios/ringtone.mp3')
                            .then((_) => _model.soundPlayer!.play());
                      } else {
                        _model.soundPlayer?.stop();
                      }

                      if (mounted) {
                        setState(() {});
                      }
                    }();
                  }
                  _model.stackPreviousSnapshot = snapshot;
                }),
              builder: (context, snapshot) {
                // Customize what your widget looks like when it's loading.
                if (!snapshot.hasData) {
                  print("==NO DATA== ${int.parse(getJsonField(
                    FFAppState()?.userInfo,
                    r'''$.id''',
                  ).toString())}");
                  return Center(
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  );
                }
                List<UsersRecord> stackUsersRecordList = snapshot.data!;
                // Return an empty Container when the item does not exist.
                if (snapshot.data!.isEmpty) {
                  print("==NO DATA==${int.parse(getJsonField(
                    FFAppState()?.userInfo,
                    r'''$.id''',
                  ).toString())}");
                  return Container();
                }
                final stackUsersRecord = stackUsersRecordList.isNotEmpty
                    ? stackUsersRecordList.first
                    : null;
                return Stack(
                  alignment: const AlignmentDirectional(0.0, 1.0),
                  children: [
                    // Generated code for this IconButton Widget...

                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: _currentPositionG == null
                          ? Center(child: CircularProgressIndicator())
                          : gflutter.GoogleMap(
                              key: _mapKey, // Lier la carte à un GlobalKey
                              initialCameraPosition: gflutter.CameraPosition(
                                target: _currentPositionG!,
                                zoom: 17,
                              ),
                              markers: {
                                gflutter.Marker(
                                  markerId: gflutter.MarkerId('vehicle'),
                                  position: _currentPositionG!,
                                  icon: _carIcon ??
                                      gflutter.BitmapDescriptor.defaultMarker,
                                ),
                              },
                              onMapCreated:
                                  (gflutter.GoogleMapController controller) {
                                print("===il est MAP CREE ===");
                                if (_controllerg != null) {
                                  _controllerg?.dispose();
                                }
                                _controllerg = controller;
                                _isMapCreated = true;
                                _moveCameraIfValid();
                                _loadCarIcon();
                              },
                              myLocationEnabled: false,
                              myLocationButtonEnabled: false,
                            ),

                      //  HereMap(onMapCreated: _onMapCreated, key: _key),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              StreamBuilder<List<RideRequestRecord>>(
                                stream: queryRideRequestRecord(
                                  queryBuilder: (rideRequestRecord) =>
                                      rideRequestRecord
                                          .where(
                                            'id',
                                            isEqualTo:
                                                stackUsersRecord?.idRequest,
                                          )
                                          .where(
                                            'status',
                                            isEqualTo: _model.statut,
                                          ),
                                  singleRecord: true,
                                )..listen((snapshot) {
                                    List<RideRequestRecord>
                                        containerRideRequestRecordList =
                                        snapshot;
                                    final containerRideRequestRecord =
                                        containerRideRequestRecordList
                                                .isNotEmpty
                                            ? containerRideRequestRecordList
                                                .first
                                            : null;
                                    if (_model.containerPreviousSnapshot !=
                                            null &&
                                        !const ListEquality(
                                                RideRequestRecordDocumentEquality())
                                            .equals(
                                                containerRideRequestRecordList,
                                                _model
                                                    .containerPreviousSnapshot)) {
                                      () async {
                                        if (containerRideRequestRecord
                                                ?.status ==
                                            'new_ride_requested') {
                                          _model.resDis = await actions
                                              .sendGetRequestWithParams(
                                            '${stackUsersRecord?.latitude},${stackUsersRecord?.longitude}',
                                            '${containerRideRequestRecord?.startLatitude?.toString()},${containerRideRequestRecord?.startLongitude?.toString()}',
                                            _model.viaNull.toList(),
                                            FFAppConstants.hereMapApiKey,
                                            'summary',
                                          );
                                          _model.distanceChauffeurClient =
                                              functions
                                                  .distanceAndDuration(
                                                      _model.resDis!.toList())
                                                  .first;
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        }
                                        if (mounted) {
                                          setState(() {});
                                        }
                                        ;
                                      }();
                                    }
                                    _model.containerPreviousSnapshot = snapshot;
                                  }),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  // BgLauncher.bringAppToForeground();
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  List<RideRequestRecord>
                                      containerRideRequestRecordList =
                                      snapshot.data!;
                                  // Return an empty Container when the item does not exist.
                                  if (snapshot.data!.isEmpty) {
                                    FlutterRingtonePlayer().stop();
                                    return Container();
                                  }
                                  final containerRideRequestRecord =
                                      containerRideRequestRecordList.isNotEmpty
                                          ? containerRideRequestRecordList.first
                                          : null;
                                  return Material(
                                    color: Colors.transparent,
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Visibility(
                                        visible:
                                            stackUsersRecord?.idRequest != 0,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 5.0, 5.0, 0.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFF39D259),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            const Icon(
                                                              Icons.add_alert,
                                                              color:
                                                                  Colors.white,
                                                              size: 10.0,
                                                            ),
                                                            Text(
                                                              'NOUVEAU',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Plus Jakarta Sans',
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        7.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                            ),
                                                          ].divide(
                                                              const SizedBox(
                                                                  width: 3.0)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Image.network(
                                                          containerRideRequestRecord!
                                                              .riderPhoto,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${containerRideRequestRecord?.riderFirstname} ${containerRideRequestRecord?.riderLastname}'
                                                                .maybeHandleOverflow(
                                                              maxChars: 20,
                                                              replacement: '…',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                          // Generated code for this Text Widget...
                                                          Text(
                                                            'Client à ${_model.distanceChauffeurClient.toStringAsFixed(2)}  Km',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          )
                                                        ].divide(const SizedBox(
                                                            height: 5.0)),
                                                      ),
                                                    ].divide(const SizedBox(
                                                        width: 10.0)),
                                                  ),
                                                  // Generated code for this Text Widget...
                                                  Text(
                                                    '${containerRideRequestRecord?.montant?.toString()} FCFA',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          fontSize: 18,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            LinearTimer(
                                                color: const Color.fromARGB(
                                                    255, 199, 95, 218),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 244, 183, 255),
                                                duration:
                                                    const Duration(seconds: 25),
                                                forward: false,
                                                minHeight: 3,
                                                onTimerStart: () async {
                                                  FlutterRingtonePlayer().play(
                                                    fromAsset:
                                                        "assets/audios/ringtone.mp3",
                                                    looping: true,
                                                    volume: .25,
                                                    asAlarm: true,
                                                  );
                                                },
                                                onTimerEnd: () async {
                                                  // Appeler la fonction pour décliner automatiquement
                                                  FlutterRingtonePlayer()
                                                      .stop();

                                                  // _model.apiResulthfz =
                                                  //     await ApisGoBabiGroup
                                                  //         .rideRequestRespondCall
                                                  //         .call(
                                                  //   token: FFAppState().token,
                                                  //   id: containerRideRequestRecord
                                                  //       ?.id,
                                                  //   driverId: getJsonField(
                                                  //     FFAppState().userInfo,
                                                  //     r'''$.id''',
                                                  //   ),
                                                  //   isAccept: 0,
                                                  // );
                                                  // if ((_model.apiResulthfz
                                                  //         ?.succeeded ??
                                                  //     true)) {
                                                  //   ScaffoldMessenger.of(
                                                  //           context)
                                                  //       .showSnackBar(
                                                  //     SnackBar(
                                                  //       content: Text(
                                                  //         'Vous avez décliné la commande',
                                                  //         style: TextStyle(
                                                  //           color: FlutterFlowTheme
                                                  //                   .of(context)
                                                  //               .primaryBackground,
                                                  //           fontWeight:
                                                  //               FontWeight.w600,
                                                  //         ),
                                                  //       ),
                                                  //       duration: Duration(
                                                  //           milliseconds: 4000),
                                                  //       backgroundColor:
                                                  //           FlutterFlowTheme.of(
                                                  //                   context)
                                                  //               .primary,
                                                  //     ),
                                                  //   );
                                                  // } else {
                                                  //   ScaffoldMessenger.of(
                                                  //           context)
                                                  //       .showSnackBar(
                                                  //     SnackBar(
                                                  //       content: Text(
                                                  //         'Une erreur est survenue',
                                                  //         style: TextStyle(
                                                  //           color: Colors.white,
                                                  //           fontWeight:
                                                  //               FontWeight.w600,
                                                  //         ),
                                                  //       ),
                                                  //       duration: Duration(
                                                  //           milliseconds: 4000),
                                                  //       backgroundColor:
                                                  //           FlutterFlowTheme.of(
                                                  //                   context)
                                                  //               .error,
                                                  //     ),
                                                  //   );
                                                  // }

                                                  _model.apiResulti97f =
                                                      await ApisGoBabiGroup
                                                          .updateUserConnexionCall
                                                          .call(
                                                    id: getJsonField(
                                                      FFAppState().userInfo,
                                                      r'''$.id''',
                                                    ),
                                                    status: 'active',
                                                    isOnline: 1,
                                                    isAvailable: 1,
                                                    token: FFAppState().token,
                                                  );

                                                  if ((_model.apiResulti97f
                                                          ?.succeeded ??
                                                      true)) {
                                                    print(
                                                        "REMIS A DISPOSITION");
                                                    _model.enLigne = true;
                                                    FFAppState().isOnline = 1;
                                                    FFAppState().statut =
                                                        'active';
                                                    FFAppState().isAvailable =
                                                        1;
                                                    setState(() {});
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Une erreur ${_model.apiResulti97c?.statusCode} est survenue veuillez réessayer',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                      ),
                                                    );
                                                    _model.enLigne = true;
                                                    setState(() {});
                                                    setState(() {
                                                      _model.switchValue = true;
                                                    });
                                                  }
                                                  _updateStatusRiderRequest();
                                                  setState(() {});
                                                }),

                                            // Divider(
                                            //   thickness: 1.0,
                                            //   color: FlutterFlowTheme.of(context)
                                            //       .alternate,
                                            // ),
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          35.0, 35.0, 0.0, 0.0),
                                                  child: Container(
                                                    width: 1.0,
                                                    height: containerRideRequestRecord
                                                                    ?.arretCoordonnee !=
                                                                null &&
                                                            containerRideRequestRecord
                                                                    ?.arretCoordonnee !=
                                                                ''
                                                        ? 120.0
                                                        : 60.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(10.0, 10.0,
                                                          0.0, 20.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Material(
                                                              color: Colors
                                                                  .transparent,
                                                              elevation: 3.0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/bonhomme.png',
                                                                    width: 30.0,
                                                                    height:
                                                                        30.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Départ',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Plus Jakarta Sans',
                                                                        color: const Color(
                                                                            0xFF898A8B),
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    containerRideRequestRecord
                                                                        ?.startAddress,
                                                                    '-',
                                                                  ).maybeHandleOverflow(
                                                                    maxChars:
                                                                        30,
                                                                    replacement:
                                                                        '…',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Plus Jakarta Sans',
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ].divide(
                                                              const SizedBox(
                                                                  width: 20.0)),
                                                        ),
                                                      ),
                                                      if ((containerRideRequestRecord
                                                                      ?.arretCoordonnee !=
                                                                  null &&
                                                              containerRideRequestRecord
                                                                      ?.arretCoordonnee !=
                                                                  '') &&
                                                          (containerRideRequestRecord
                                                                  ?.arretCoordonnee !=
                                                              'null') &&
                                                          (containerRideRequestRecord
                                                                  ?.arretCoordonnee !=
                                                              'NULL'))
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  14.0,
                                                                  10.0,
                                                                  0.0,
                                                                  10.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Material(
                                                                color: Colors
                                                                    .transparent,
                                                                elevation: 3.0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/stop.png',
                                                                      width:
                                                                          20.0,
                                                                      height:
                                                                          20.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '${functions.parseAndConvertToJson(containerRideRequestRecord?.arretCoordonnee)?.length?.toString()} arrets ...',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Plus Jakarta Sans',
                                                                          color:
                                                                              const Color(0xFF8F8F8F),
                                                                          letterSpacing:
                                                                              0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                  )
                                                                ],
                                                              ),
                                                            ].divide(
                                                                const SizedBox(
                                                                    width:
                                                                        20.0)),
                                                          ),
                                                        ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Material(
                                                              color: Colors
                                                                  .transparent,
                                                              elevation: 3.0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/orange.png',
                                                                    width: 30.0,
                                                                    height:
                                                                        30.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Arrivée',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Plus Jakarta Sans',
                                                                        color: const Color(
                                                                            0xFF898A8B),
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    containerRideRequestRecord
                                                                        ?.endAddress,
                                                                    '-',
                                                                  ).maybeHandleOverflow(
                                                                    maxChars:
                                                                        30,
                                                                    replacement:
                                                                        '…',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Plus Jakarta Sans',
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ].divide(
                                                              const SizedBox(
                                                                  width: 20.0)),
                                                        ),
                                                      ),
                                                    ].divide(const SizedBox(
                                                        height: 10.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      20.0, 0.0, 20.0, 20.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  speakText(
                                                      "C'est une course ${containerRideRequestRecord?.serviceName} ${containerRideRequestRecord?.serviceName.toLowerCase() == 'business' || containerRideRequestRecord?.serviceName.toLowerCase() == 'suv' ? ',veuillez activer la climatisation' : ''}");

                                                  _model.apiResultu8g =
                                                      await ApisGoBabiGroup
                                                          .rideRequestRespondCall
                                                          .call(
                                                    token: FFAppState().token,
                                                    driverId: getJsonField(
                                                      FFAppState().userInfo,
                                                      r'''$.id''',
                                                    ),
                                                    isAccept: 1,
                                                    id: containerRideRequestRecord
                                                        ?.id,
                                                  );

                                                  if ((_model.apiResultu8g
                                                          ?.succeeded ??
                                                      true)) {
                                                    saveDocumentToFirebase(
                                                        getJsonField(
                                                          FFAppState().userInfo,
                                                          r'''$.id''',
                                                        ),
                                                        containerRideRequestRecord
                                                            ?.riderId,
                                                        containerRideRequestRecord!
                                                            .id,
                                                        containerRideRequestRecord
                                                            ?.duration,
                                                        containerRideRequestRecord
                                                            ?.distance);

                                                    context.pushNamed(
                                                      'infosTrajet',
                                                      queryParameters: {
                                                        'idCourse':
                                                            serializeParam(
                                                          containerRideRequestRecord
                                                              ?.id,
                                                          ParamType.int,
                                                        ),
                                                        'depart':
                                                            serializeParam(
                                                          <String, dynamic>{
                                                            'display_name':
                                                                containerRideRequestRecord
                                                                    ?.startAddress,
                                                            'latitude':
                                                                containerRideRequestRecord
                                                                    ?.startLatitude,
                                                            'longitude':
                                                                containerRideRequestRecord
                                                                    ?.startLongitude,
                                                          },
                                                          ParamType.JSON,
                                                        ),
                                                        'arrivee':
                                                            serializeParam(
                                                          <String, dynamic>{
                                                            'display_name':
                                                                containerRideRequestRecord
                                                                    ?.endAddress,
                                                            'longitude':
                                                                containerRideRequestRecord
                                                                    ?.endLongitude,
                                                            'latitude':
                                                                containerRideRequestRecord
                                                                    ?.endLatitude,
                                                          },
                                                          ParamType.JSON,
                                                        ),
                                                        'distanceClientChauffeurDepart':
                                                            serializeParam(
                                                                _model
                                                                    .distanceChauffeurClient,
                                                                ParamType
                                                                    .double),
                                                        'arret': containerRideRequestRecord
                                                                        ?.arretCoordonnee !=
                                                                    null &&
                                                                containerRideRequestRecord
                                                                        ?.arretCoordonnee !=
                                                                    ''
                                                            ? serializeParam(
                                                                functions.parseAndConvertToJson(
                                                                    containerRideRequestRecord
                                                                        ?.arretCoordonnee),
                                                                ParamType.JSON,
                                                                isList: true,
                                                              )
                                                            : [],
                                                      }.withoutNulls,
                                                    );

                                                    _model.soundPlayer?.stop();
                                                  } else {
                                                    print(
                                                        "==ERREUR ${_model.apiResultu8g?.statusCode}  ");
                                                  }

                                                  setState(() {});
                                                },
                                                text: 'Accepter la course',
                                                options: FFButtonOptions(
                                                  width: double.infinity,
                                                  height: 50.0,
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  iconPadding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 0.0, 0.0, 0.0),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            color: Colors.white,
                                                            letterSpacing: 0.0,
                                                          ),
                                                  elevation: 0.0,
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (stackUsersRecord?.idRequest == 0)
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Material(
                                          color: Colors.transparent,
                                          elevation: 3.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Visibility(
                                              visible: (ApisGoBabiGroup
                                                          .currentRideRequestCall
                                                          .statut(
                                                        (_model.laRideReq
                                                                ?.jsonBody ??
                                                            ''),
                                                      ) ==
                                                      'completed') ||
                                                  (ApisGoBabiGroup
                                                          .currentRideRequestCall
                                                          .statut(
                                                        (_model.laRideReq
                                                                ?.jsonBody ??
                                                            ''),
                                                      ) ==
                                                      'canceled') ||
                                                  (getJsonField(
                                                        (_model.laRideReq
                                                                ?.jsonBody ??
                                                            ''),
                                                        r'''$.id''',
                                                      ) ==
                                                      null),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if ((_model.apiResultmze !=
                                                          null) &&
                                                      (ApisGoBabiGroup
                                                              .walletCheckCall
                                                              .djai(
                                                            (_model.apiResultmze
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )! <
                                                          ApisGoBabiGroup
                                                              .walletCheckCall
                                                              .leMin(
                                                            (_model.apiResultmze
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )!)) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          'Rechargez vous pour pouvoir faire des courses',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                      ),
                                                    );
                                                  } else {
                                                    _model.chargeRech = true;
                                                    setState(() {});
                                                    _model.resGeo =
                                                        await ReverseGeocodeCall
                                                            .call(
                                                      at: '${stackUsersRecord?.latitude},${stackUsersRecord?.longitude}',
                                                    );
                                                    if ((_model.resGeo
                                                            ?.succeeded ??
                                                        true)) {
                                                      context.pushNamed(
                                                        'creationTrajet',
                                                        queryParameters: {
                                                          'depart':
                                                              serializeParam(
                                                            <String, dynamic>{
                                                              'display_name':
                                                                  functions.reconv(
                                                                      ReverseGeocodeCall
                                                                          .displayname(
                                                                (_model.resGeo
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              )!),
                                                              'latitude': double.parse(
                                                                  stackUsersRecord
                                                                          ?.latitude
                                                                      as String),
                                                              'longitude': double.parse(
                                                                  stackUsersRecord
                                                                          ?.longitude
                                                                      as String),
                                                            },
                                                            ParamType.JSON,
                                                          ),
                                                          'prevInterface':
                                                              serializeParam(
                                                            'pageAccueil',
                                                            ParamType.String,
                                                          ),
                                                          'focus':
                                                              serializeParam(
                                                            'arrivee',
                                                            ParamType.String,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                      _model.chargeRech = false;
                                                      setState(() {});
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: const Text(
                                                            'Une erreur est survenue veuillez réessayer',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      4000),
                                                          backgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .error,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(5.0,
                                                              0.0, 0.0, 0.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/3671579.jpg',
                                                          height: 70.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'COMMANDER ',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                fontSize: 15.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        Text(
                                                          'POUR UN CLIENT',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: const Color(
                                                                    0xFF707070),
                                                                fontSize: 15.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ].divide(const SizedBox(
                                                          height: 5.0)),
                                                    ),
                                                    Container(
                                                      width: 50.0,
                                                      height: 90.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  0.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  0.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  20.0),
                                                        ),
                                                      ),
                                                      child: // Generated code for this ConditionalBuilder Widget...
                                                          Builder(
                                                        builder: (context) {
                                                          if (_model
                                                                  .chargeRech ==
                                                              false) {
                                                            return const Icon(
                                                              Icons
                                                                  .arrow_forward_ios_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 24,
                                                            );
                                                          } else {
                                                            return Lottie.asset(
                                                              'assets/lottie_animations/Animation_-_1720180021970.json',
                                                              width: 40,
                                                              height: 40,
                                                              fit: BoxFit
                                                                  .contain,
                                                              animate: true,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if ((ApisGoBabiGroup
                                                    .currentRideRequestCall
                                                    .statut(
                                                  (_model.laRideReq?.jsonBody ??
                                                      ''),
                                                ) !=
                                                'completed') &&
                                            (ApisGoBabiGroup
                                                    .currentRideRequestCall
                                                    .statut(
                                                  (_model.laRideReq?.jsonBody ??
                                                      ''),
                                                ) !=
                                                'canceled') &&
                                            (_model.laRideReq != null) &&
                                            (getJsonField(
                                                  (_model.laRideReq?.jsonBody ??
                                                      ''),
                                                  r'''$.id''',
                                                ) !=
                                                null))
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                'infosTrajet',
                                                queryParameters: {
                                                  'idCourse': serializeParam(
                                                    getJsonField(
                                                      _model.rideActuelle,
                                                      r'''$.id''',
                                                    ),
                                                    ParamType.int,
                                                  ),
                                                  'depart': serializeParam(
                                                    <String, dynamic>{
                                                      'display_name':
                                                          getJsonField(
                                                        _model.rideActuelle,
                                                        r'''$.start_address''',
                                                      ),
                                                      'latitude': double.parse(
                                                          getJsonField(
                                                        _model.rideActuelle,
                                                        r'''$.start_latitude''',
                                                      )),
                                                      'longitude': double.parse(
                                                          getJsonField(
                                                        _model.rideActuelle,
                                                        r'''$.start_longitude''',
                                                      )),
                                                    },
                                                    ParamType.JSON,
                                                  ),
                                                  'arrivee': serializeParam(
                                                    <String, dynamic>{
                                                      'display_name':
                                                          getJsonField(
                                                        _model.rideActuelle,
                                                        r'''$.end_address''',
                                                      ),
                                                      'latitude': double.parse(
                                                          getJsonField(
                                                        _model.rideActuelle,
                                                        r'''$.end_latitude''',
                                                      )),
                                                      'longitude': double.parse(
                                                          getJsonField(
                                                        _model.rideActuelle,
                                                        r'''$.end_longitude''',
                                                      )),
                                                    },
                                                    ParamType.JSON,
                                                  ),
                                                  'arret': getJsonField(
                                                                _model
                                                                    .rideActuelle,
                                                                r'''$.arret_coordonnee''',
                                                              ).toString() !=
                                                              null &&
                                                          getJsonField(
                                                                _model
                                                                    .rideActuelle,
                                                                r'''$.arret_coordonnee''',
                                                              ).toString() !=
                                                              ''
                                                      ? serializeParam(
                                                          functions
                                                              .parseAndConvertToJson(
                                                                  getJsonField(
                                                            _model.rideActuelle,
                                                            r'''$.arret_coordonnee''',
                                                          ).toString()),
                                                          ParamType.JSON,
                                                          isList: true,
                                                        )
                                                      : [],
                                                }.withoutNulls,
                                              );
                                            },
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  1.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF3EEFF),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                getJsonField(
                                                                  _model
                                                                      .rideActuelle,
                                                                  r'''$.id''',
                                                                ).toString(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Plus Jakarta Sans',
                                                                      color: const Color(
                                                                          0xFFC7C7C7),
                                                                      fontSize:
                                                                          10.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xFF754CE3),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                  child: Text(
                                                                    () {
                                                                      if (getJsonField(
                                                                            _model.rideActuelle,
                                                                            r'''$.status''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            FFAppState().leStatus.first,
                                                                            r'''$.statutEng''',
                                                                          )) {
                                                                        return 'Accepté';
                                                                      } else if (getJsonField(
                                                                            _model.rideActuelle,
                                                                            r'''$.status''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            FFAppState().leStatus[1],
                                                                            r'''$.statutEng''',
                                                                          )) {
                                                                        return 'En route';
                                                                      } else if (getJsonField(
                                                                            _model.rideActuelle,
                                                                            r'''$.status''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            FFAppState().leStatus[2],
                                                                            r'''$.statutEng''',
                                                                          )) {
                                                                        return 'Arrivé';
                                                                      } else if (getJsonField(
                                                                            _model.rideActuelle,
                                                                            r'''$.status''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            FFAppState().leStatus[3],
                                                                            r'''$.statutEng''',
                                                                          )) {
                                                                        return 'En cours';
                                                                      } else {
                                                                        return 'Terminé';
                                                                      }
                                                                    }(),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Plus Jakarta Sans',
                                                                          color:
                                                                              Colors.white,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(
                                                                const SizedBox(
                                                                    width:
                                                                        10.0)),
                                                          ),
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .keyboard_arrow_right_rounded,
                                                          color:
                                                              Color(0xFF7145D7),
                                                          size: 24.0,
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent4,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  5.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/sedan_car-rafiki.png',
                                                                    width: 40.0,
                                                                    height:
                                                                        40.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .arrow_right_alt_outlined,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .tertiary,
                                                                size: 20.0,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        10.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      getJsonField(
                                                                        _model
                                                                            .rideActuelle,
                                                                        r'''$.end_address''',
                                                                      )
                                                                          .toString()
                                                                          .maybeHandleOverflow(
                                                                            maxChars:
                                                                                15,
                                                                            replacement:
                                                                                '…',
                                                                          ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Plus Jakarta Sans',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).tertiary,
                                                                            fontSize:
                                                                                11.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${getJsonField(
                                                                        _model
                                                                            .rideActuelle,
                                                                        r'''$.distance''',
                                                                      ).toString()} Km',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Plus Jakarta Sans',
                                                                            color:
                                                                                Color(0xFF959595),
                                                                            fontSize:
                                                                                10.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .currency_franc,
                                                              color: Color(
                                                                  0xFF7145D7),
                                                              size: 14.0,
                                                            ),
                                                            Text(
                                                              '${getJsonField(
                                                                _model
                                                                    .rideActuelle,
                                                                r'''$.montant''',
                                                              ).toString()} FCFA',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Plus Jakarta Sans',
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                      ].divide(const SizedBox(height: 10.0)),
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(0.0, 1.0),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                1.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x33000000),
                                              offset: Offset(
                                                0.0,
                                                2.0,
                                              ),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10.0, 20.0, 10.0, 20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              blurRadius: 4.0,
                                                              color: Color(
                                                                  0x33000000),
                                                              offset: Offset(
                                                                0.0,
                                                                2.0,
                                                              ),
                                                            )
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                        ),
                                                        child: InkWell(
                                                          onTap: () {
                                                            print(
                                                                "==refresh==");
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            width: 35.0,
                                                            height: 35.0,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child:
                                                                Image.network(
                                                              getJsonField(
                                                                FFAppState()
                                                                    .userInfo,
                                                                r'''$.profile_image''',
                                                              ).toString(),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${getJsonField(
                                                              FFAppState()
                                                                  .userInfo,
                                                              r'''$.first_name''',
                                                            ).toString()} ${stackUsersRecord?.lastName}'
                                                                .maybeHandleOverflow(
                                                              maxChars: 15,
                                                              replacement: '…',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  color: const Color(
                                                                      0xFF754CE3),
                                                                  fontSize:
                                                                      13.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                          Text(
                                                            'Chauffeur',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ].divide(const SizedBox(
                                                        width: 10.0)),
                                                  ),
                                                  // Generated code for this Image Widget...
                                                  StreamBuilder<
                                                      List<ImgCarRecord>>(
                                                    stream: queryImgCarRecord(
                                                      queryBuilder:
                                                          (imgCarRecord) =>
                                                              imgCarRecord
                                                                  .where(
                                                        'couleur',
                                                        isEqualTo: FFAppState()
                                                            .carColor
                                                            .toLowerCase(),
                                                      ),
                                                      singleRecord: true,
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      // print(
                                                      // "car color ${FFAppState().carColor}");
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 50,
                                                            height: 50,
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                      Color>(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      List<ImgCarRecord>
                                                          imageImgCarRecordList =
                                                          snapshot.data!;
                                                      // Return an empty Container when the item does not exist.
                                                      if (snapshot
                                                          .data!.isEmpty) {
                                                        return Container();
                                                      }
                                                      final imageImgCarRecord =
                                                          imageImgCarRecordList
                                                                  .isNotEmpty
                                                              ? imageImgCarRecordList
                                                                  .first
                                                              : null;
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.network(
                                                          imageImgCarRecord!
                                                              .image,
                                                          width: 110,
                                                          height: 70,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                              Divider(
                                                thickness: 1.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        20.0, 10.0, 20.0, 10.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  5.0),
                                                          child: Container(
                                                            width: 35.0,
                                                            height: 35.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0x6939D259),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24.0),
                                                            ),
                                                            child: const Icon(
                                                              Icons
                                                                  .currency_franc,
                                                              color: Color(
                                                                  0xFF39D259),
                                                              size: 24.0,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${valueOrDefault<String>(StatCoursesMontantCall.montant(
                                                                (_model.apiResulteyo
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              )?.toString(), '0')} FCFA',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                        Text(
                                                          'Argent gagné',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: const Color(
                                                                    0xFFA4A4A4),
                                                                fontSize: 10.0,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    5.0),
                                                            child: Container(
                                                              width: 35.0,
                                                              height: 35.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0x79606A85),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24.0),
                                                              ),
                                                              child: Icon(
                                                                Icons.commute,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 24.0,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              StatCoursesMontantCall
                                                                  .nbrCourses(
                                                                (_model.apiResulteyo
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              )?.toString(),
                                                              '0',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              // showPersistentNotification();
                                                              context.pushNamed(
                                                                  'mapGoogle');
                                                            },
                                                            child: Text(
                                                              'Courses',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Plus Jakarta Sans',
                                                                    color: const Color(
                                                                        0xFFA4A4A4),
                                                                    fontSize:
                                                                        10.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Generated code for this Column Widget...
                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     print("==refresh==");
                                                    //     _keyScaf.currentState
                                                    //         ?.setState(() {});
                                                    //   },
                                                    //   child:

                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 5),
                                                          child: Container(
                                                            width: 35,
                                                            height: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0x75EE8B60),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24),
                                                            ),
                                                            child: // Generated code for this IconButton Widget...
                                                                FlutterFlowIconButton(
                                                              borderRadius: 20,
                                                              borderWidth: 1,
                                                              buttonSize: 20,
                                                              icon: Icon(
                                                                Icons
                                                                    .refresh_rounded,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .tertiary,
                                                                size: 20,
                                                              ),
                                                              showLoadingIndicator:
                                                                  true,
                                                              onPressed:
                                                                  () async {
                                                                print(
                                                                    'IconButton pressed ...');

                                                                await Future
                                                                    .wait([
                                                                  // ACTUALISATION RIDE REQUEST
                                                                  Future(
                                                                      () async {
                                                                    _model.laRideReq =
                                                                        await ApisGoBabiGroup
                                                                            .currentRideRequestCall
                                                                            .call(
                                                                      token: FFAppState()
                                                                          .token,
                                                                      id: getJsonField(
                                                                        FFAppState()
                                                                            .userInfo,
                                                                        r'''$.id''',
                                                                      ).toString().toString(),
                                                                    );

                                                                    if ((_model
                                                                            .laRideReq
                                                                            ?.succeeded ??
                                                                        true)) {
                                                                      _model
                                                                          .rideActuelle = (_model
                                                                              .laRideReq
                                                                              ?.jsonBody ??
                                                                          '');
                                                                      setState(
                                                                          () {});
                                                                    } else {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content:
                                                                              const Text(
                                                                            'Une erreur ride est survenue veuillez reessayer',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          duration:
                                                                              const Duration(milliseconds: 4000),
                                                                          backgroundColor:
                                                                              FlutterFlowTheme.of(context).error,
                                                                        ),
                                                                      );
                                                                    }
                                                                  }),
                                                                  //

                                                                  //  ACTUALISATION WALLET
                                                                  Future(
                                                                      () async {
                                                                    _model.apiResultmze =
                                                                        await ApisGoBabiGroup
                                                                            .walletCheckCall
                                                                            .call(
                                                                      token: FFAppState()
                                                                          .token,
                                                                    );

                                                                    if (!(_model
                                                                            .apiResultmze
                                                                            ?.succeeded ??
                                                                        true)) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content:
                                                                              const Text(
                                                                            'Une erreur wallet est survenue veuillez réessayer',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          duration:
                                                                              const Duration(milliseconds: 4000),
                                                                          backgroundColor:
                                                                              FlutterFlowTheme.of(context).error,
                                                                        ),
                                                                      );
                                                                    }
                                                                  }),
                                                                  //

                                                                  // ACTUALISATION STAT ET MONTANT
                                                                  Future(
                                                                      () async {
                                                                    _model.apiResulteyo =
                                                                        await StatCoursesMontantCall
                                                                            .call(
                                                                      status:
                                                                          'completed',
                                                                      driverId:
                                                                          getJsonField(
                                                                        FFAppState()
                                                                            .userInfo,
                                                                        r'''$.id''',
                                                                      ),
                                                                      startDate: functions
                                                                          .startandend(
                                                                              getCurrentTimestamp)
                                                                          .first
                                                                          .toString(),
                                                                      endDate: functions
                                                                          .startandend(
                                                                              getCurrentTimestamp)
                                                                          .last
                                                                          .toString(),
                                                                    );

                                                                    if (!(_model
                                                                            .apiResulteyo
                                                                            ?.succeeded ??
                                                                        true)) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content:
                                                                              Text(
                                                                            'Une erreur ${_model.apiResulteyo?.statusCode} est survenue , veuillez réessayer',
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          duration:
                                                                              const Duration(milliseconds: 4000),
                                                                          backgroundColor:
                                                                              FlutterFlowTheme.of(context).error,
                                                                        ),
                                                                      );
                                                                    }
                                                                  }),
                                                                  //

                                                                  //  ACTUALISATION USER DETAIL
                                                                  Future(
                                                                      () async {
                                                                    _model.apiResultsh1 =
                                                                        await ApisGoBabiGroup
                                                                            .userDetailCall
                                                                            .call(
                                                                      userId:
                                                                          getJsonField(
                                                                        FFAppState()
                                                                            .userInfo,
                                                                        r'''$.id''',
                                                                      ),
                                                                      token: FFAppState()
                                                                          .token,
                                                                    );

                                                                    if ((_model
                                                                            .apiResultsh1
                                                                            ?.succeeded ??
                                                                        true)) {
                                                                      FFAppState()
                                                                              .carYear =
                                                                          ApisGoBabiGroup
                                                                              .userDetailCall
                                                                              .carProdYear(
                                                                        (_model.apiResultsh1?.jsonBody ??
                                                                            ''),
                                                                      )!;
                                                                      FFAppState()
                                                                              .carPlate =
                                                                          ApisGoBabiGroup
                                                                              .userDetailCall
                                                                              .carPlateNumber(
                                                                        (_model.apiResultsh1?.jsonBody ??
                                                                            ''),
                                                                      )!;
                                                                      FFAppState()
                                                                              .carModel =
                                                                          ApisGoBabiGroup
                                                                              .userDetailCall
                                                                              .carModel(
                                                                        (_model.apiResultsh1?.jsonBody ??
                                                                            ''),
                                                                      )!;
                                                                      FFAppState()
                                                                              .carColor =
                                                                          ApisGoBabiGroup
                                                                              .userDetailCall
                                                                              .carColor(
                                                                        (_model.apiResultsh1?.jsonBody ??
                                                                            ''),
                                                                      )!;
                                                                      setState(
                                                                          () {});
                                                                    } else {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content:
                                                                              Text(
                                                                            'Une erreur est survenue',
                                                                            style:
                                                                                TextStyle(
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          duration:
                                                                              const Duration(milliseconds: 4000),
                                                                          backgroundColor:
                                                                              FlutterFlowTheme.of(context).error,
                                                                        ),
                                                                      );
                                                                    }
                                                                  }),
                                                                  //
                                                                ]);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        const Text(
                                                                      'Interface actualisée',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            4000),
                                                                    backgroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .success,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          'Actualiser',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                        Text(
                                                          'Interface',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: const Color(
                                                                    0xFFA4A4A4),
                                                                fontSize: 10.0,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        )
                                                      ],
                                                    ),
                                                    // )
                                                  ].divide(const SizedBox(
                                                      width: 10.0)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 10.0)),
                                ),
                              if ((_model.apiResultmze != null) &&
                                  (ApisGoBabiGroup.walletCheckCall.djai(
                                        (_model.apiResultmze?.jsonBody ?? ''),
                                      )! <
                                      ApisGoBabiGroup.walletCheckCall.leMin(
                                        (_model.apiResultmze?.jsonBody ?? ''),
                                      )!))
                                Material(
                                  color: Colors.transparent,
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/wallet.gif',
                                              width: 100.0,
                                              height: 100.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Text(
                                            'Veuillez vous recharger pour avoir des courses',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () async {
                                              context.pushNamed('portefeuille');
                                            },
                                            text: 'Se recharger',
                                            options: FFButtonOptions(
                                              height: 40.0,
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                              iconPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                              elevation: 3.0,
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ].divide(const SizedBox(height: 20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                            ].divide(const SizedBox(height: 10.0)),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(1, -1),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // FlutterFlowIconButton(
                            //   borderColor: FlutterFlowTheme.of(context).primary,
                            //   borderRadius: 10,
                            //   borderWidth: 1,
                            //   buttonSize: 40,
                            //   fillColor: FlutterFlowTheme.of(context).primary,
                            //   icon: Icon(
                            //     Icons.location_searching,
                            //     color: FlutterFlowTheme.of(context)
                            //         .secondaryBackground,
                            //     size: 24,
                            //   ),
                            //   onPressed: () async {
                            //     const double distanceToEarthInMeters = 3000;
                            //     MapMeasure mapMeasureZoom = MapMeasure(
                            //         MapMeasureKind.distance,
                            //         distanceToEarthInMeters);
                            //     hereMapCont!.camera.lookAtPointWithMeasure(
                            //         GeoCoordinates(
                            //             FFAppState().userPosition!.latitude,
                            //             FFAppState().userPosition!.longitude),
                            //         mapMeasureZoom);
                            //   },
                            // ),

                            // Generated code for this Badge Widget...
                            StreamBuilder<List<ReservationsRecord>>(
                              stream: queryReservationsRecord(
                                queryBuilder: (reservationsRecord) =>
                                    reservationsRecord
                                        .where(
                                          'status',
                                          isEqualTo: _model.enattente,
                                        )
                                        .where(
                                          'dateheure',
                                          isGreaterThan: getCurrentTimestamp,
                                        ),
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                List<ReservationsRecord>
                                    badgeReservationsRecordList =
                                    snapshot.data!;
                                return badges.Badge(
                                  badgeContent: Text(
                                    badgeReservationsRecordList.length
                                        .toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  showBadge: true,
                                  shape: badges.BadgeShape.circle,
                                  badgeColor:
                                      FlutterFlowTheme.of(context).tertiary,
                                  elevation: 4,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 8, 8, 8),
                                  position: badges.BadgePosition.topEnd(),
                                  animationType:
                                      badges.BadgeAnimationType.scale,
                                  toAnimate: true,
                                  child: FlutterFlowIconButton(
                                    borderColor:
                                        FlutterFlowTheme.of(context).primary,
                                    borderRadius: 10,
                                    borderWidth: 1,
                                    buttonSize: 40,
                                    fillColor:
                                        FlutterFlowTheme.of(context).primary,
                                    icon: FaIcon(
                                      FontAwesomeIcons.solidBell,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      size: 24,
                                    ),
                                    onPressed: () async {
                                      context.pushNamed('listeReservations');
                                    },
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Future<void> startBubbleFunction(BuildContext context) async {
//   try {
//     print('56');
//     final hasStarted = await _startBubble(
//       bubbleOptions: BubbleOptions(
//         bubbleIcon: "ic_driver_dark",
//         startLocationX: 0,
//         startLocationY: 100,
//         bubbleSize: 100,
//         opacity: 1,
//         enableClose: false,
//         closeBehavior: CloseBehavior.fixed,
//         //distanceToClose: 100,
//         enableAnimateToEdge: false,
//         enableBottomShadow: false,
//         keepAliveWhenAppExit: true,
//       ),
//       onTap: () async {
//         // Ouvrir l'application lorsque la bulle est tapée
//         // Ouvrir l'application lorsque la bulle est tapée
//         final intent = AndroidIntent(
//           action: 'android.intent.action.MAIN',
//           package: 'com.gobabidrive',
//           flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
//         );
//         await intent.launch();
//       },
//     );

//     if (hasStarted == true) {
//       print("Bubble is started");
//     } else {
//       print('Bubble has not started');
//     }
//   } catch (e, stackTrace) {
//     print('Exception occurred: $e');
//     print('Stack trace: $stackTrace');
//     // Traitez l'exception selon vos besoins
//   }
// }

// Future<bool> _startBubble({
//   BubbleOptions? bubbleOptions,
//   VoidCallback? onTap,
// }) async {
//   return await DashBubble.instance.startBubble(
//     bubbleOptions: bubbleOptions,
//     onTap: onTap,
//   );
// }

// Future<bool> _stopBubble() async {
//   return await DashBubble.instance.stopBubble();
// }

// Future<void> stopBubbleFunction() async {
//   final hasStopped = await _stopBubble();
//   // Vous pouvez ajouter d'autres logiques ici si nécessaire
// }
class LocationTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('onStart(starter: ${starter.name})');
    final locationSettings = LocationSettings(
      accuracy: geolocator.LocationAccuracy.high,
      distanceFilter: 10, // Recevoir une mise à jour tous les 10 mètres
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print('Position back: ${position.latitude}, ${position.longitude}');
      // Envoyer la position à un serveur ou à Firebase ici.
    });
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    // Si vous souhaitez répéter certaines actions
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // Nettoyez les ressources ici
    _positionStreamSubscription?.cancel();
  }
}

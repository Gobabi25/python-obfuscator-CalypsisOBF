import 'dart:async';
import 'dart:ui';

import 'package:app_to_foreground/app_to_foreground.dart';
import 'package:bg_launcher/bg_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_babi_drive/CustomNavigatorObserver.dart';
import 'package:go_babi_drive/ShowNavig.dart';
import 'package:go_babi_drive/components/notif_bulle/notif_bulle_widget.dart';
import 'package:go_babi_drive/no_connexion/no_connexion_widget.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/core.engine.dart';
// import 'package:here_sdk/core.errors.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;

import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//     as bg;
import 'package:location/location.dart' as loc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  // await initializeService();
  await initFirebase();

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  // Vérification de la connectivité
  // var connectivityResult = await Connectivity().checkConnectivity();

  // bool hasInternet = connectivityResult != ConnectivityResult.none;

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: OverlaySupport.global(child: MyApp()),
  ));
}
// Future<void> showForegroundNotification() async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'foreground_service_channel', // id du canal
//     'Foreground Service', // nom du canal
//     channelDescription: 'Notification for foreground service',
//     importance: Importance.low,
//     priority: Priority.low,
//     ongoing: true, // Rendre la notification persistante
//   );

//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);

//   await flutterLocalNotificationsPlugin.show(
//     0, // id de la notification
//     'Service en cours d\'exécution', // titre
//     'Votre service est en cours d\'exécution', // corps
//     platformChannelSpecifics,
//   );
// }

Future<void> initializeService() async {
  print("notif foreground==");
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "1", // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  showForegroundNotification();

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
        autoStart: true,
        onStart: onStart,
        isForegroundMode: true,
        autoStartOnBoot: true,
        notificationChannelId: "1"),
  );
  print("===notif foreground==");
}

Future<void> showForegroundNotification() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'foreground_service_channel',
    'Foreground Service',
    channelDescription: 'Notification for foreground service',
    importance: Importance.low,
    priority: Priority.low,
    ongoing: true,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Service en cours d\'exécution',
    'Votre service est en cours d\'exécution',
    platformChannelSpecifics,
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  print("===ARRIERE COMMENCE===");
  DartPluginRegistrant.ensureInitialized();

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // Timer.periodic(Duration(seconds: 5), (Timer timer) async {
  //   print("derriere");
  //   // await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0))
  //   //     .then((value) {
  //   //   print(value.latitude);
  //   // });
  // });
  // loc.Location location = loc.Location();
  // location.onLocationChanged.listen((loc.LocationData currentLocation) {
  //   print("==position ${currentLocation.longitude}");
  // });
  // _getLocationUpdates();
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  bool displaySplashImage = true;

  final FlutterTts flutterTts = FlutterTts();

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isNavigationVisible = false;
  final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    _requestNotificationPermission();
    // _loadNavigationVisibility();

    // _initializeHERESDK();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    Future.delayed(const Duration(milliseconds: 1000),
        () => setState(() => _appStateNotifier.stopShowingSplashImage()));
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Future<void> _loadNavigationVisibility() async {
  //   final visible = await NavigationService.getIsNavigationVisible();
  //   setState(() {
  //     _isNavigationVisible = visible;
  //   });
  // }

  Future<void> showPersistentNotification(String a) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'persistent_channel', // ID du canal
      'Persistent Notifications', // Nom du canal
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      usesChronometer: true,

      styleInformation: BigTextStyleInformation(''),

      // actions: <AndroidNotificationAction>[
      //   // Définir des actions pour la notification
      //   AndroidNotificationAction(
      //     'ACCEPT_ACTION',
      //     'Accepter',
      //     showsUserInterface: true,
      //     cancelNotification: false,
      //   ),
      //   AndroidNotificationAction(
      //     'REJECT_ACTION',
      //     'Refuser',
      //     showsUserInterface: true,
      //     cancelNotification: false,
      //   ),
      // ],

      // Cela rend la notification persistante
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notification
      'Notification Persistante',
      a,
      platformChannelSpecifics,
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
    if (_connectionStatus[0] == ConnectivityResult.none) {
      print("CONNECTIVITY DECO");
    }
  }

  void _sendBroadcastIntent() {
    print("=====BROADCOAST======");
    final AndroidIntent intent = AndroidIntent(
      action: 'com.gobabidrive.NOTIFICATION_ACTION',
    );
    intent.sendBroadcast();
    print("=====BROADCOAST======");
  }

  // void _initializeHERESDK() async {
  //   // Needs to be called before accessing SDKOptions to load necessary libraries.
  //   SdkContext.init(IsolateOrigin.main);

  //   // Set your credentials for the HERE SDK.
  //   String accessKeyId = "KhUlv43yK7AkzMHegg4_KA";
  //   String accessKeySecret =
  //       "FPH7UbBdR3M2LhdNK2gZAVVjpp3qXh0o95pJj00otlnFP8F2kVam4kS0S17ZFFQ1a60oUstnSrEMjCE8WtqTqw";
  //   SDKOptions sdkOptions =
  //       SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  //   try {
  //     await SDKNativeEngine.makeSharedInstance(sdkOptions);
  //   } on InstantiationException {
  //     throw Exception("Failed to initialize the HERE SDK.");
  //   }
  // }

  Future<void> _requestForegroundPermission() async {
    final sysAllow = await permissions.Permission.systemAlertWindow.request();
  }

  Future<void> speakText(String text) async {
    await flutterTts.setLanguage("fr-fr");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  Future<void> _requestNotificationPermission() async {
    print("DEMANDE NOTIF");
    final status = await permissions.Permission.notification.request();
    if (status == permissions.PermissionStatus.denied) {
      // L'utilisateur a refusé les notifications, vous pouvez afficher un message
      print("NOTIFICATION REFUSEE");
    } else {
      print("NOTIFICATION ACCEPTEE");

      OneSignal.initialize(FFAppConstants.mOneSignalAppIdDriver);

      await initializeService();

      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        showSimpleNotification(
            NotifBulleWidget(
              titre: 'Gobabi',
              content: event.notification.body,
            ),
            elevation: 0,
            background: Colors.transparent,
            duration: const Duration(seconds: 2));
        speakText('${event.notification.body}');

        showPersistentNotification('${event.notification.body}');

        event.preventDefault();
        event.notification.display();
      });
      if (FFAppState().playerId == '') {
        OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
        OneSignal.Debug.setAlertLevel(OSLogLevel.none);
        OneSignal.consentRequired(false);
        OneSignal.Notifications.requestPermission(true);
        OneSignal.initialize(FFAppConstants.mOneSignalAppIdDriver);

        await saveOneSignalPlayerId().then((value) {
          print("player id enregistrement ");
        }).catchError((onError) => {print("player id error $onError  ")});
      } else {
        print("player id not empty");
      }
      _requestForegroundPermission();
    }
  }

  Future<void> saveOneSignalPlayerId() async {
    // await OneSignal.shared.getDeviceState().then((value) async {
    // });
    print("PLAYER ID ONE SIGNAL");
    OneSignal.User.pushSubscription.addObserver((state) async {
      print("==PLAYER ID ONE SIGNAL");
      print(OneSignal.User.pushSubscription.optedIn);
      print("Player Id" + OneSignal.User.pushSubscription.id.toString());
      print(OneSignal.User.pushSubscription.token);
      print(state.current.jsonRepresentation());

      if (OneSignal.User.pushSubscription.id != null) {
        FFAppState().playerId = OneSignal.User.pushSubscription.id!;
      }
    });
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return _connectionStatus[0] == ConnectivityResult.none
        ? const MaterialApp(home: NoConnexionWidget())
        : MaterialApp.router(
            title: 'Go Babi Drive',
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', '')],
            theme: ThemeData(
              brightness: Brightness.light,
              useMaterial3: false,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: false,
            ),
            themeMode: _themeMode,
            routerConfig: _router,
            builder: (context, child) {
              return Stack(
                children: [
                  child!,
                  ValueListenableBuilder<bool>(
                    valueListenable: NavigationService().isNavigationVisible,
                    builder: (context, visible, _) {
                      return Visibility(
                        visible: visible,
                        child: Align(
                          alignment: AlignmentDirectional(0, 1),
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  )
                ],
              );
            },
          );
  }
}

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:go_babi_drive/backend/backend.dart';
import 'package:go_babi_drive/backend/schema/ride_request_record.dart';
import 'package:url_launcher/url_launcher.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'navigation_model.dart';
export 'navigation_model.dart';

import '/flutter_flow/custom_functions.dart' as functions;
import '/custom_code/actions/index.dart' as actions;
import '../../main.dart'; // Assure-toi d'importer routeObserver ici

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({
    super.key,
    this.depart,
    this.arrivee,
    this.arrets,
    this.idCourse,
    // required this.routeObserver,
  });

  final dynamic depart;
  final dynamic arrivee;
  final List<dynamic>? arrets;
  final int? idCourse;
  // final RouteObserver<Route> routeObserver;

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  late NavigationModel _model;
  String? _platformVersion;
  String? _instruction;
  final _origin = WayPoint(
      name: "Way Point 1",
      latitude: 38.9111117447887,
      longitude: -77.04012393951416,
      isSilent: true);
  final _stop1 = WayPoint(
      name: "Way Point 2",
      latitude: 38.91113678979344,
      longitude: -77.03847169876099,
      isSilent: true);
  final _stop2 = WayPoint(
      name: "Way Point 3",
      latitude: 38.91040213277608,
      longitude: -77.03848242759705,
      isSilent: false);
  final _stop3 = WayPoint(
      name: "Way Point 4",
      latitude: 38.909650771013034,
      longitude: -77.03850388526917,
      isSilent: true);
  final _destination = WayPoint(
      name: "Way Point 5",
      latitude: 38.90894949285854,
      longitude: -77.03651905059814,
      isSilent: false);

  final _home = WayPoint(
      name: "Home",
      latitude: 37.77440680146262,
      longitude: -122.43539772352648,
      isSilent: false);

  final _store = WayPoint(
      name: "Store",
      latitude: 37.76556957793795,
      longitude: -122.42409811526268,
      isSilent: false);

  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _inFreeDrive = false;
  bool _cacher = false;
  MapBoxOptions? _navigationOption;
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();
  Timer? _timer;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isListenerRegistered = false;
  Key _mapboxKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialize();
    });

    print("==vari ${widget.idCourse}");
  }

  void _refreshMap() {
    setState(() {
      _mapboxKey = UniqueKey(); // 🔄 force reconstruction
    });
  }

  @override
  void dispose() {
    // setState(() {
    //   _routeBuilt = false;
    //   _isNavigating = false;
    // });
    // widget.routeObserver.unsubscribe(this);
    _controller?.finishNavigation();
    MapBoxNavigation.instance.finishNavigation();
    _controller?.dispose();
    // MapBoxNavigation.instance.unregisterRouteEventListener(_onEmbeddedRouteEvent); // Ajoute ça
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  // }

  // @override
  // void didPopNext() {
  //   // 🔙 Called when returning to this screen
  //   print("Returned to NavigationPage — rebuilding MapBoxNavigationView");
  //   _refreshMap();
  // }

  _onWillPop() {
    // Vérifiez si vous souhaitez bloquer le bouton retour ou effectuer une action
    // Vous pouvez bloquer le retour en renvoyant `false` ou déclencher une action
    print('==pop==');
    // Par exemple, terminer la navigation si le controller est disponible :
    if (_controller != null) {
      _controller!.finishNavigation(); // Exécuter l'action de votre controller
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    // _navigationOption?.simulateRoute = false;
    _navigationOption?.language = "fr";
    _navigationOption?.mapStyleUrlDay =
        "mapbox://styles/terranutraespciale/cm6i8s1ip00hq01r5dg6rfvm2";

    _navigationOption?.mapStyleUrlNight =
        "mapbox://styles/terranutraespciale/cm6i8s1ip00hq01r5dg6rfvm2";
    // _navigationOption?.bannerInstructionsEnabled = true;
    // _navigationOption?.voiceInstructionsEnabled = true;
    _navigationOption?.showEndOfRouteFeedback = true;
    // _navigationOption?.animateBuildRoute = true;
    // _navigationOption?.isOptimized = true;

    _navigationOption?.units = VoiceUnits.metric;

    //_navigationOption.initialLatitude = 36.1175275;
    //_navigationOption.initialLongitude = -115.1839524;
    if (!_isListenerRegistered) {
      MapBoxNavigation.instance
          .registerRouteEventListener(_onEmbeddedRouteEvent);
      _isListenerRegistered = true;
    }

    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onPopInvoked: _onWillPop(),
      canPop: false,
      child: MaterialApp(
        home: Scaffold(
          appBar: // Generated code for this AppBar Widget...
              AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlutterFlowIconButton(
                  borderRadius: 8,
                  buttonSize: 40,
                  fillColor: FlutterFlowTheme.of(context).primary,
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: FlutterFlowTheme.of(context).info,
                    size: 24,
                  ),
                  onPressed: () async {
                    setState(() {
                      _routeBuilt = false;
                      _isNavigating = false;
                    });
                    _controller?.finishNavigation();
                    MapBoxNavigation.instance.finishNavigation();
                    _controller?.dispose();
                    // context.pop();
                    context.pop();
                    context.pushReplacementNamed(
                      'infosTrajet',
                      queryParameters: {
                        'idCourse': serializeParam(
                          widget.idCourse,
                          ParamType.int,
                        ),
                        'depart': serializeParam(
                          <String, dynamic>{
                            'display_name': widget.depart["display_name"],
                            'latitude': widget.depart["latitude"],
                            'longitude': widget.depart["longitude"],
                          },
                          ParamType.JSON,
                        ),
                        'arrivee': serializeParam(
                          <String, dynamic>{
                            'display_name': widget.arrivee["display_name"],
                            'latitude': widget.arrivee["latitude"],
                            'longitude': widget.arrivee["longitude"],
                          },
                          ParamType.JSON,
                        ),
                      }.withoutNulls,
                    );
                  },
                ),
                Text(
                  'Navigation',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 0.0,
                      ),
                ),
              ].divide(SizedBox(width: 10)),
            ),
            actions: [],
            centerTitle: false,
            elevation: 2,
          ),
          body: Center(
            child: Column(children: <Widget>[
              // Expanded(
              //   child: SingleChildScrollView(
              //     child: Column(
              //       children: [
              //         const SizedBox(
              //           height: 10,
              //         ),
              //         Container(
              //           color: Colors.grey,
              //           width: double.infinity,
              //           child: const Padding(
              //             padding: EdgeInsets.all(10),
              //             child: (Text(
              //               "Embedded Navigation",
              //               style: TextStyle(color: Colors.white),
              //               textAlign: TextAlign.center,
              //             )),
              //           ),
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             ElevatedButton(
              //               onPressed: _isNavigating
              //                   ? null
              //                   : () {
              //                       if (_routeBuilt) {
              //                         _controller?.clearRoute();
              //                       } else {
              //                         var wayPoints = <WayPoint>[];
              //                         final departurePoint = WayPoint(
              //                           name: widget.depart["display_name"],
              //                           latitude: widget.depart!["latitude"],
              //                           longitude: widget.depart!["longitude"],
              //                         );
              //                         final arrivalPoint = WayPoint(
              //                           name: widget.arrivee["display_name"],
              //                           latitude: widget.arrivee!["latitude"],
              //                           longitude: widget.arrivee!["longitude"],
              //                         );
              //                         wayPoints.add(departurePoint);
              //                         wayPoints.add(arrivalPoint);
              //                         _isMultipleStop = wayPoints.length > 2;
              //                         _controller?.buildRoute(
              //                             wayPoints: wayPoints,
              //                             options: _navigationOption);
              //                       }
              //                     },
              //               child: Text(_routeBuilt && !_isNavigating
              //                   ? "Clear Route"
              //                   : "Build Route"),
              //             ),
              //             const SizedBox(
              //               width: 10,
              //             ),
              //             ElevatedButton(
              //               onPressed: _routeBuilt && !_isNavigating
              //                   ? () {
              //                       _controller?.startNavigation();
              //                     }
              //                   : null,
              //               child: const Text('Start '),
              //             ),
              //             const SizedBox(
              //               width: 10,
              //             ),
              //             ElevatedButton(
              //               onPressed: _isNavigating
              //                   ? () {
              //                       _controller?.finishNavigation();
              //                     }
              //                   : null,
              //               child: const Text('Cancel '),
              //             )
              //           ],
              //         ),
              //         // ElevatedButton(
              //         //   onPressed: _inFreeDrive
              //         //       ? null
              //         //       : () async {
              //         //           _inFreeDrive =
              //         //               await _controller?.startFreeDrive() ?? false;
              //         //         },
              //         //   child: const Text("Free Drive "),
              //         // ),
              //         // const Center(
              //         //   child: Padding(
              //         //     padding: EdgeInsets.all(10),
              //         //     child: Text(
              //         //       "Long-Press Embedded Map to Set Destination",
              //         //       textAlign: TextAlign.center,
              //         //     ),
              //         //   ),
              //         // ),
              //         const Divider()
              //       ],
              //     ),
              //   ),
              // ),

              // Expanded(
              // child:
              SizedBox(
                height: 660,
                child: Container(
                  color: Colors.grey,
                  child: Stack(children: [
                    MapBoxNavigationView(
                        key: _mapboxKey,
                        options: _navigationOption,
                        onRouteEvent: _onEmbeddedRouteEvent,
                        onCreated:
                            (MapBoxNavigationViewController controller) async {
                          _controller = controller;

                          controller.initialize();
                          var wayPoints = <WayPoint>[];
                          final departurePoint = WayPoint(
                            name: 'depart',
                            latitude: getJsonField(
                              FFAppState().userPositionData,
                              r'''$.latitude''',
                            ),
                            longitude: getJsonField(
                              FFAppState().userPositionData,
                              r'''$.longitude''',
                            ),
                          );
                          final arrivalPoint = WayPoint(
                            name: widget.arrivee["display_name"],
                            latitude: widget.arrivee!["latitude"],
                            longitude: widget.arrivee!["longitude"],
                          );
                          wayPoints.add(departurePoint);
                          wayPoints.add(arrivalPoint);
                          _isMultipleStop = wayPoints.length > 2;
                          _controller?.buildRoute(
                              wayPoints: wayPoints,
                              options: MapBoxOptions(
                                simulateRoute:
                                    false, // Simuler ou non l'itinéraire
                                voiceInstructionsEnabled:
                                    true, // Instructions vocales activées
                                language:
                                    "fr", // Langue des instructions vocales
                                animateBuildRoute:
                                    true, // Animation pendant la construction de l'itinéraire
                                bannerInstructionsEnabled:
                                    true, // Instructions de bannière activées
                                isOptimized:
                                    true, // Optimisation de l'itinéraire
                              ));
                        }),

                    // Align(
                    //   alignment: AlignmentDirectional(1, 1),
                    //   child: Visibility(
                    //     visible: _cacher,
                    //     child: Container(
                    //       width: 90,
                    //       height: 90,
                    //       decoration: BoxDecoration(
                    //         color:
                    //             FlutterFlowTheme.of(context).secondaryBackground,
                    //       ),
                    //       child: // Generated code for this Row Widget...
                    //           Visibility(
                    //         visible: !_isNavigating,
                    //         child: Row(
                    //           mainAxisSize: MainAxisSize.max,
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             FlutterFlowIconButton(
                    //               borderRadius: 8,
                    //               buttonSize: 40,
                    //               fillColor: FlutterFlowTheme.of(context).primary,
                    //               icon: Icon(
                    //                 Icons.navigation_rounded,
                    //                 color: FlutterFlowTheme.of(context).info,
                    //                 size: 24,
                    //               ),
                    //               onPressed: () {
                    //                 if (_routeBuilt && !_isNavigating) {
                    //                   _controller?.startNavigation();
                    //                 }
                    //               },
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    //le draggable
                    StreamBuilder<List<RideRequestRecord>>(
                        stream: queryRideRequestRecord(
                          queryBuilder: (rideRequestRecord) =>
                              rideRequestRecord.where(
                            'id',
                            isEqualTo: widget.idCourse,
                          ),
                          singleRecord: true,
                        )..listen((snapshot) {
                            print("sendGetRequestWithParams99");
                            List<RideRequestRecord> stackRideRequestRecordList =
                                snapshot;
                            final stackRideRequestRecord =
                                stackRideRequestRecordList.isNotEmpty
                                    ? stackRideRequestRecordList.first
                                    : null;

                            // _model.stackPreviousSnapshot = snapshot;
                          }),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
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
                          List<RideRequestRecord> stackRideRequestRecordList =
                              snapshot.data!;
                          // Return an empty Container when the item does not exist.
                          if (snapshot.data!.isEmpty) {
                            return Container();
                          }
                          final stackRideRequestRecord =
                              stackRideRequestRecordList.isNotEmpty
                                  ? stackRideRequestRecordList.first
                                  : null;
                          return DraggableScrollableSheet(
                            controller: _draggableController,
                            initialChildSize:
                                0.20, // Taille initiale (40% de l'écran)
                            minChildSize:
                                0.20, // Taille minimale (20% de l'écran)
                            maxChildSize:
                                0.6, // Taille maximale (60% de l'écran)
                            builder: (BuildContext context,
                                ScrollController scrollController) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Color(0x33000000),
                                      offset: Offset(
                                        0,
                                        2,
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: Divider(
                                            thickness: 3,
                                            color: Color(0x4F6F61EF),
                                          ),
                                        ),
                                        // Generated code for this Button Widget...
                                        _cacher
                                            ? Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  FFButtonWidget(
                                                    onPressed: () {
                                                      print(
                                                          'Button pressed ...');
                                                      if (_routeBuilt &&
                                                          !_isNavigating) {
                                                        _controller
                                                            ?.startNavigation();
                                                      }
                                                      setState(() {
                                                        _cacher = false;
                                                      });
                                                    },
                                                    text: 'Commencer',
                                                    icon: Icon(
                                                      Icons.navigation_rounded,
                                                      size: 15,
                                                    ),
                                                    options: FFButtonOptions(
                                                      height: 40,
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16, 0, 16, 0),
                                                      iconPadding:
                                                          EdgeInsets.all(0),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      elevation: 0,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Durée trajet',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color: Color(
                                                                  0xFF959595),
                                                              fontSize: 13.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                            ),
                                                      ),
                                                      Text(
                                                        stackRideRequestRecord
                                                                    ?.status ==
                                                                'arrived'
                                                            ? valueOrDefault<
                                                                String>(
                                                                functions.formatDuration(
                                                                    stackRideRequestRecord!
                                                                        .duration),
                                                                '0',
                                                              )
                                                            : (_durationRemaining !=
                                                                    null
                                                                ? valueOrDefault<
                                                                    String>(
                                                                    functions.formatDuration(
                                                                        _durationRemaining!
                                                                            .round()),
                                                                    '0',
                                                                  )
                                                                : ''),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 10.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1.0,
                                              height: 20.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Distance trajet',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color: Color(
                                                                  0xFF959595),
                                                              fontSize: 13.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                            ),
                                                      ),
                                                      Text(
                                                        stackRideRequestRecord
                                                                    ?.status ==
                                                                'arrived'
                                                            ? '${stackRideRequestRecord?.distance?.toString()}Km'
                                                            : '${_distanceRemaining != null ? (_distanceRemaining! / 1000).toStringAsFixed(2) + ' Km' : ''}',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 10.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1.0,
                                              height: 20.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Prix',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color: Color(
                                                                  0xFF959595),
                                                              fontSize: 13.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                            ),
                                                      ),
                                                      Text(
                                                        '${stackRideRequestRecord?.montant?.toString()} F',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 10.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Generated code for this Divider Widget...
                                        const Divider(
                                          thickness: 1,
                                          color: Color(0xFFEBEEF2),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                // Generated code for this CircleImage Widget...
                                                Container(
                                                  width: 35,
                                                  height: 35,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Image.network(
                                                    stackRideRequestRecord!
                                                        .riderPhoto,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Image.asset(
                                                      'assets/images/ic_app_logo.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      stackRideRequestRecord
                                                                      ?.otherRiderData !=
                                                                  null &&
                                                              stackRideRequestRecord
                                                                      ?.otherRiderData !=
                                                                  ''
                                                          ? '${valueOrDefault<String>(
                                                              getJsonField(
                                                                functions.transforToJson(
                                                                    stackRideRequestRecord!
                                                                        .otherRiderData),
                                                                r'''$.other_first_name''',
                                                              )?.toString(),
                                                              '-',
                                                            )} ${getJsonField(
                                                              functions.transforToJson(
                                                                  stackRideRequestRecord!
                                                                      .otherRiderData),
                                                              r'''$.other_last_name''',
                                                            ).toString()}'
                                                          : '${stackRideRequestRecord?.riderFirstname} ${stackRideRequestRecord?.riderLastname}'
                                                              .maybeHandleOverflow(
                                                              maxChars: 18,
                                                              replacement: '…',
                                                            ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            stackRideRequestRecord
                                                                ?.serviceName,
                                                            '-',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                fontSize: 10.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ].divide(SizedBox(width: 10.0)),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 35.0,
                                                  height: 35.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9.0),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      String numero = '';
                                                      if (stackRideRequestRecord
                                                                  ?.otherRiderData !=
                                                              null &&
                                                          stackRideRequestRecord
                                                                  ?.otherRiderData !=
                                                              '') {
                                                        numero =
                                                            'tel:${getJsonField(
                                                          functions.transforToJson(
                                                              stackRideRequestRecord!
                                                                  .otherRiderData),
                                                          r'''$.other_contact_number''',
                                                        ).toString()}';
                                                      } else {
                                                        numero =
                                                            'tel:${stackRideRequestRecord?.riderContact}';
                                                      }
                                                      launchUrl(
                                                          Uri.parse(numero),
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    },
                                                    child: Icon(
                                                      Icons.call_outlined,
                                                      color: Color(0xFF7145D7),
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 35.0,
                                                  height: 35.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.message_outlined,
                                                    color: Color(0xFF7145D7),
                                                    size: 24.0,
                                                  ),
                                                ),
                                                // Container(
                                                //   width: 35.0,
                                                //   height: 35.0,
                                                //   decoration: BoxDecoration(
                                                //     color: FlutterFlowTheme.of(
                                                //             context)
                                                //         .secondaryBackground,
                                                //     borderRadius:
                                                //         BorderRadius.circular(
                                                //             9.0),
                                                //   ),
                                                //   child: Icon(
                                                //     Icons.star_sharp,
                                                //     color: FlutterFlowTheme.of(
                                                //             context)
                                                //         .warning,
                                                //     size: 24.0,
                                                //   ),
                                                // ),
                                              ].divide(SizedBox(width: 10.0)),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          color: Color(0xFFEBEEF2),
                                        ),

                                        // LES BOUTONS //
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        })
                  ]),
                ),
              ),
              // )
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        _distanceRemaining = progressEvent.distance;
        _durationRemaining = progressEvent.duration;
        print(
            "==distance et temps restante $_distanceRemaining , $_durationRemaining");
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
        print("====NAVIGATION ROUTE BUILDING");
        break;
      case MapBoxEvent.route_built:
        print("====NAVIGATION ROUTE BUILT");
        _controller?.startNavigation();

        setState(() {
          _cacher = false;
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        print("====NAVIGATION ROUTE BUILT FAILED");
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        print("====NAVIGATION RUNNING");
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
        print("====NAVIGATION TERMINEE");
        await Future.delayed(const Duration(seconds: 3));
        await _controller?.finishNavigation();
        context.pushReplacementNamed(
          'infosTrajet',
          queryParameters: {
            'idCourse': serializeParam(
              widget.idCourse,
              ParamType.int,
            ),
            'depart': serializeParam(
              <String, dynamic>{
                'display_name': widget.depart["display_name"],
                'latitude': widget.depart["latitude"],
                'longitude': widget.depart["longitude"],
              },
              ParamType.JSON,
            ),
            'arrivee': serializeParam(
              <String, dynamic>{
                'display_name': widget.arrivee["display_name"],
                'latitude': widget.arrivee["latitude"],
                'longitude': widget.arrivee["longitude"],
              },
              ParamType.JSON,
            ),
          }.withoutNulls,
        );
        break;
      case MapBoxEvent.navigation_cancelled:
        print("====NAVIGATION ANNULEE");
        await Future.delayed(const Duration(seconds: 3));
        await _controller?.finishNavigation();
        context.pushReplacementNamed(
          'infosTrajet',
          queryParameters: {
            'idCourse': serializeParam(
              widget.idCourse,
              ParamType.int,
            ),
            'depart': serializeParam(
              <String, dynamic>{
                'display_name': widget.depart["display_name"],
                'latitude': widget.depart["latitude"],
                'longitude': widget.depart["longitude"],
              },
              ParamType.JSON,
            ),
            'arrivee': serializeParam(
              <String, dynamic>{
                'display_name': widget.arrivee["display_name"],
                'latitude': widget.arrivee["latitude"],
                'longitude': widget.arrivee["longitude"],
              },
              ParamType.JSON,
            ),
          }.withoutNulls,
        );
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        print("====NAVIGATION DEFAULT");
        break;
    }
    setState(() {});
  }
}

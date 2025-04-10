import 'dart:async';

import 'package:app_to_foreground/app_to_foreground.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:go_babi_drive/ShowNavig.dart';
import 'package:go_babi_drive/components/notif_bulle/notif_bulle_widget.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/core.errors.dart';
// import 'package:here_sdk/gestures.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:here_sdk/routing.dart';
// import 'package:here_sdk/search.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/annulation/annulation_widget.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'infos_trajet_model.dart';
export 'infos_trajet_model.dart';

import 'package:flutter_tts/flutter_tts.dart';

// import 'package:here_sdk/animation.dart' as here;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gflutter;
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'
    as ltln;
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfosTrajetWidget extends StatefulWidget {
  const InfosTrajetWidget({
    super.key,
    this.idCourse,
    this.depart,
    this.arrivee,
    this.arret,
    bool? change,
    this.serviceId,
    this.distanceClientChauffeurDepart,
  }) : this.change = change ?? false;

  final int? idCourse;
  final dynamic depart;
  final dynamic arrivee;
  final List<dynamic>? arret;
  final bool change;
  final int? serviceId;
  final double? distanceClientChauffeurDepart;

  @override
  State<InfosTrajetWidget> createState() => _InfosTrajetWidgetState();
}

class _InfosTrajetWidgetState extends State<InfosTrajetWidget> {
  late InfosTrajetModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  double departLat = 0.0;
  double departLon = 0.0;
  double arriveeLat = 0.0;
  double arriveeLon = 0.0;
  // HereMapController? hereMapCont;
  UniqueKey _key = UniqueKey();
  // late SearchEngine _onlineSearchEngine;
  bool useOnlineSearchEngine = true;
  // List<MapPolyline> _mapPolylines = [];
  final FlutterTts flutterTts = FlutterTts();
  StreamController<List<UsersRecord>>? _streamController;
  StreamSubscription? _subscription;
  ltln.LatLng? _currentPositionG;
  ltln.LatLng? _currentPositionA;

  gflutter.BitmapDescriptor? _startIcon;
  gflutter.BitmapDescriptor? _endIcon;
  gflutter.GoogleMapController? _controllerg;
  Set<gflutter.Polyline> polylines = {};
  Key _mapKey = UniqueKey();

  bool _isNavigationVisible = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InfosTrajetModel());
    // try {
    //   _onlineSearchEngine = SearchEngine();
    // } on InstantiationException {
    //   throw ("Initialization of SearchEngine failed.");
    // }
    print('=====sendGetRequestWithParams2=====');
    Stream<List<UsersRecord>> _stream = queryUsersRecord(
      queryBuilder: (usersRecord) => usersRecord.where(
        'id',
        isEqualTo: getJsonField(
          FFAppState().userInfo,
          r'''$.id''',
        ),
      ),
      singleRecord: true,
    );
    print('=====sendGetRequestWithParams3=====');

    _subscription = _stream.listen((snapshot) {
      print('=====sendGetRequestWithParams4=====');
    });

    departLat = getJsonField(
      widget.depart,
      r'''$.latitude''',
    );

    departLon = getJsonField(
      widget.depart,
      r'''$.longitude''',
    );

    arriveeLat = getJsonField(
      widget.arrivee,
      r'''$.latitude''',
    );

    arriveeLon = getJsonField(
      widget.arrivee,
      r'''$.longitude''',
    );
    _currentPositionG = ltln.LatLng(departLat, departLon);
    _currentPositionA = ltln.LatLng(arriveeLat, arriveeLon);
    _loadCarIcon();
    drawRoute();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget!.distanceClientChauffeurDepart != null) {
        _model.distanceChauffeurClient = widget!.distanceClientChauffeurDepart;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    polylines.clear();
    _controllerg?.dispose();
    _subscription?.cancel();
    _model.dispose();

    super.dispose();
  }

  Future<void> speakText(String text) async {
    await flutterTts.setLanguage("fr-fr");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak("$text");
  }

  // Future<void> _toggleNavigationVisibility() async {
  //   setState(() {
  //     _isNavigationVisible = !_isNavigationVisible;
  //   });
  //   await NavigationService.setIsNavigationVisible(_isNavigationVisible);
  // }

// LA MAP GOOGLE //
  Future<void> drawRoute() async {
    final String url =
        "https://router.project-osrm.org/route/v1/driving/${_currentPositionG?.longitude},${_currentPositionG?.latitude};${_currentPositionA?.longitude},${_currentPositionA?.latitude}?overview=full&geometries=geojson";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['routes'][0]['geometry']['coordinates'];

      List<ltln.LatLng> points =
          coordinates.map((coord) => ltln.LatLng(coord[1], coord[0])).toList();
      double totalDistance = data['routes'][0]['distance']; // en mètres
      double totalDuration = data['routes'][0]['duration'];

      setState(() {
        polylines.clear();
        polylines.add(gflutter.Polyline(
          polylineId: gflutter.PolylineId("route"),
          points: points,
          color: Colors.blue,
          width: 5,
        ));
        //  _model.duration = totalDuration;
        //  _model.distance = totalDistance / 1000;
      });
    }
  }

  Future<void> _loadCarIcon() async {
    _startIcon = await gflutter.BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      'assets/images/bonhomme.png',
    );

    _endIcon = await gflutter.BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      'assets/images/orange.png',
    );
  }

  void _reloadMap() {
    setState(() {
      _mapKey = UniqueKey(); // nouvelle instance
    });
  }

  void _moveCameraToFitBounds(ltln.LatLng start, ltln.LatLng end) async {
    print("====DEBUT BOUGE CAMERA=====");

    // Calcul des limites en fonction des deux points
    final double minLat =
        start.latitude < end.latitude ? start.latitude : end.latitude;
    final double maxLat =
        start.latitude > end.latitude ? start.latitude : end.latitude;
    final double minLng =
        start.longitude < end.longitude ? start.longitude : end.longitude;
    final double maxLng =
        start.longitude > end.longitude ? start.longitude : end.longitude;

    gflutter.LatLngBounds bounds = gflutter.LatLngBounds(
      southwest: gflutter.LatLng(minLat, minLng),
      northeast: gflutter.LatLng(maxLat, maxLng),
    );

    try {
      // Déplacer la caméra pour couvrir la zone délimitée par les bounds
      print("bouge : $bounds");
      await _controllerg?.animateCamera(
        gflutter.CameraUpdate.newLatLngBounds(bounds, 60), // 60 est le padding
      );
      print("====FIN BOUGE CAMERA=====");
    } catch (e) {
      print("Erreur lors du déplacement de la caméra : $e");
    }

    print("====FIN BOUGE CAMERA=====");
  }

//

  // TOUT DE LA MAP
  // void _onMapCreated(HereMapController hereMapController) {
  //   print("LA MAP======");
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
  //         GeoCoordinates(FFAppState().userPosition!.latitude,
  //             FFAppState().userPosition!.longitude),
  //         mapMeasureZoom);
  //   });

  //   // hereMapController.mapScene.enableFeatures(
  //   //     {MapFeatures.trafficFlow: MapFeatureModes.trafficFlowWithFreeFlow});

  //   addRoute(hereMapController, GeoCoordinates(departLat, departLon),
  //       GeoCoordinates(arriveeLat, arriveeLon));
  //   _cameraStateListener(hereMapController);
  // }

  // MONTRE LE TRAJET SUR LA CARTE

//   Future<void> addRoute(HereMapController hereMapController,
//       GeoCoordinates startPoint, GeoCoordinates endPoint) async {
//     RoutingEngine _routingEngine = RoutingEngine();

//     Waypoint startWaypoint = Waypoint.withDefaults(startPoint);
//     Waypoint arret1Waypoint;
//     Waypoint endWaypoint = Waypoint.withDefaults(endPoint);
//     List<Waypoint> waypoints = [];

// // ajout depart
//     waypoints.add(startWaypoint);
//     _addMapMarker(hereMapController, startPoint, "assets/images/bonhomme.png");
// //

// // ajout arrets
//     if (widget.arret != null && widget.arret?.length != 0) {
//       for (int i = 0; i < widget.arret!.length; i++) {
//         GeoCoordinates arretGeo = GeoCoordinates(
//             getJsonField(
//               widget.arret![i],
//               r'''$.latitude''',
//             ),
//             getJsonField(
//               widget.arret![i],
//               r'''$.longitude''',
//             ));
//         arret1Waypoint = Waypoint.withDefaults(arretGeo);
//         waypoints.add(arret1Waypoint);
//         _addMapMarker(hereMapController, arretGeo, "assets/images/stop.png");
//       }
//     }
// //

// // ajout arrivee
//     waypoints.add(endWaypoint);
//     _addMapMarker(hereMapController, endPoint, "assets/images/orange.png");
// //

//     _routingEngine.calculateCarRoute(waypoints, CarOptions(),
//         (RoutingError? routingError, routeList) async {
//       if (routingError == null) {
//         // When error is null, it is guaranteed that the list is not empty.
//         var route = routeList!.first;
//         Section firstSection = route.sections.first;
//         TrafficSpeed firstTrafficSpeed = firstSection.spans.first.trafficSpeed;

//         // _showRouteDetails(route);
//         _showRouteOnMap(hereMapController, route);
//         _animateToRoute(hereMapController, route);
//         _logRouteSectionDetails(route);
//         // _logRouteViolations(route);
//       } else {
//         var error = routingError.toString();
//         // _showDialog('Error', 'Error while calculating a route: $error');
//       }
//     });
//   }

//   _showRouteOnMap(HereMapController hereMapController, route) {
//     // Show route as polyline.
//     GeoPolyline routeGeoPolyline = route.geometry;
//     double widthInPixels = 20;
//     Color polylineColor = const Color.fromARGB(160, 0, 144, 138);
//     MapPolyline routeMapPolyline;
//     try {
//       routeMapPolyline = MapPolyline.withRepresentation(
//           routeGeoPolyline,
//           MapPolylineSolidRepresentation(
//               MapMeasureDependentRenderSize.withSingleSize(
//                   RenderSizeUnit.pixels, widthInPixels),
//               polylineColor,
//               LineCap.round));
//       hereMapController.mapScene.addMapPolyline(routeMapPolyline);
//       _mapPolylines.add(routeMapPolyline);
//     } on MapPolylineRepresentationInstantiationException catch (e) {
//       print("MapPolylineRepresentation Exception:" + e.error.name);
//       return;
//     } on MapMeasureDependentRenderSizeInstantiationException catch (e) {
//       print("MapMeasureDependentRenderSize Exception:" + e.error.name);
//       return;
//     }
//   }

//   void _animateToRoute(HereMapController _hereMapController, route) {
//     // The animation results in an untilted and unrotated map.
//     double bearing = 0;
//     double tilt = 0;
//     // We want to show the route fitting in the map view with an additional padding of 50 pixels.
//     Point2D origin = Point2D(50, 50);
//     Size2D sizeInPixels = Size2D(_hereMapController.viewportSize.width - 100,
//         _hereMapController.viewportSize.height - 100);
//     Rectangle2D mapViewport = Rectangle2D(origin, sizeInPixels);

//     // Animate to the route within a duration of 3 seconds.
//     MapCameraUpdate update =
//         MapCameraUpdateFactory.lookAtAreaWithGeoOrientationAndViewRectangle(
//             route.boundingBox,
//             GeoOrientationUpdate(bearing, tilt),
//             mapViewport);
//     MapCameraAnimation animation =
//         MapCameraAnimationFactory.createAnimationFromUpdateWithEasing(
//             update,
//             const Duration(milliseconds: 1000),
//             here.Easing(here.EasingFunction.inCubic));
//     _hereMapController.camera.startAnimation(animation);
//   }

//   void _addMapMarker(HereMapController _hereMapController,
//       GeoCoordinates geoCoordinates, String image) {
//     int imageWidth = 90;
//     int imageHeight = 90;
//     MapImage mapImage =
//         MapImage.withFilePathAndWidthAndHeight(image, imageWidth, imageHeight);
//     MapMarker mapMarker = MapMarker(geoCoordinates, mapImage);
//     _hereMapController.mapScene.addMapMarker(mapMarker);
//   }

  // void _logRouteSectionDetails(route) {
  //   DateFormat dateFormat = DateFormat().add_Hm();
  //   var total = 0;
  //   var totalDuration = 0;
  //   for (int i = 0; i < route.sections.length; i++) {
  //     Section section = route.sections.elementAt(i);

  //     print("Route Section : " + (i + 1).toString());
  //     print("Route Section Departure Time : " +
  //         dateFormat.format(section.departureLocationTime!.localTime));
  //     print("Route Section Arrival Time : " +
  //         dateFormat.format(section.arrivalLocationTime!.localTime));
  //     print(
  //         "Route Section length : " + section.lengthInMeters.toString() + " m");
  //     print("Route Section duration : " +
  //         section.duration.inSeconds.toString() +
  //         " s");

  //     total += section.lengthInMeters;
  //     totalDuration += section.duration.inSeconds;
  //   }
  //   print('Route total ${total / 1000}');
  //   print('duration total $totalDuration');
  //   // setState(() {
  //   //   _model.duration = totalDuration;
  //   //   _model.distance = total / 1000;
  //   // });

  //   // estimatePrice();
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
  //       // _getAddressForCoordinates(centerCoordinates);
  //     }
  //   });
  // }

//

  int roundUpToNearestHundred(double value) {
    return ((value / 100).ceil() * 100).toInt();
  }

  //

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title:
              // Generated code for this Row Widget...
              Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FlutterFlowIconButton(
                    borderColor: FlutterFlowTheme.of(context).primary,
                    borderRadius: 20,
                    borderWidth: 1,
                    buttonSize: 40,
                    fillColor: FlutterFlowTheme.of(context).accent1,
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () async {
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      }
                      context.pushNamed('HomePage');
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      final current =
                          NavigationService().isNavigationVisible.value;
                      await NavigationService()
                          .setIsNavigationVisible(!current);
                    },
                    child: Text(
                      'Infos course',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 0,
                              ),
                    ),
                  ),
                ].divide(SizedBox(width: 20)),
              ),
              // Generated code for this Button Widget...
              FFButtonWidget(
                onPressed: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () => _model.unfocusNode.canRequestFocus
                            ? FocusScope.of(context)
                                .requestFocus(_model.unfocusNode)
                            : FocusScope.of(context).unfocus(),
                        child: Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: AnnulationWidget(
                            rideId: widget!.idCourse.toString(),
                          ),
                        ),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                },
                text: 'Annuler',
                options: FFButtonOptions(
                  height: 40,
                  padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: FlutterFlowTheme.of(context).error,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                  elevation: 3,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              )
            ],
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                    child: StreamBuilder<List<RideRequestRecord>>(
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
                          if (_model.stackPreviousSnapshot != null &&
                              !const ListEquality(
                                      RideRequestRecordDocumentEquality())
                                  .equals(stackRideRequestRecordList,
                                      _model.stackPreviousSnapshot)) {
                            () async {
                              if (stackRideRequestRecord?.status ==
                                      'canceled' &&
                                  _model.stackPreviousSnapshot?.first.status !=
                                      stackRideRequestRecord?.status) {
                                MapBoxNavigation.instance.finishNavigation();
                                if (Navigator.of(context).canPop()) {
                                  context.pop();
                                }

                                // Navigator.pop(context);

                                context.pushNamed('HomePage');

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'La course a été annulée',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                );
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
                        return Container(
                          // height: double.infinity,
                          child: Stack(
                            alignment: AlignmentDirectional(0.0, 1.0),
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, -1.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 120),
                                  child: Stack(
                                    // mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
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
                                                    // Generated code for this Text Widget...
                                                    if (mounted)
                                                      if (stackRideRequestRecord
                                                                  ?.status ==
                                                              'arriving' ||
                                                          (stackRideRequestRecord
                                                                  ?.status ==
                                                              'accepted') ||
                                                          (stackRideRequestRecord
                                                                  ?.status ==
                                                              'in_progress'))
                                                        Text(
                                                          'Client à ${(_model.distanceChauffeurClient!).toStringAsFixed(2)} Km',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: Colors
                                                                    .orange,
                                                                fontSize: 15,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                        ),

                                                    // Text(
                                                    //   'Arrive dans 10 min',
                                                    //   style: FlutterFlowTheme.of(
                                                    //           context)
                                                    //       .bodyMedium
                                                    //       .override(
                                                    //         fontFamily:
                                                    //             'Plus Jakarta Sans',
                                                    //         color: FlutterFlowTheme
                                                    //                 .of(context)
                                                    //             .secondaryText,
                                                    //         fontSize: 10.0,
                                                    //         letterSpacing: 0.0,
                                                    //         fontWeight:
                                                    //             FontWeight.w300,
                                                    //       ),
                                                    // ),
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
                                                  child: InkWell(
                                                    onTap: () {
                                                      launchUrl(
                                                          Uri.parse(
                                                              'sms:${stackRideRequestRecord?.riderContact}'),
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    },
                                                    child: Icon(
                                                      Icons.message_outlined,
                                                      color: Color(0xFF7145D7),
                                                      size: 24.0,
                                                    ),
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
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 200.0,
                                          //  HereMap(
                                          //     onMapCreated: _onMapCreated,
                                          //     key: _key),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            // image: DecorationImage(
                                            //   fit: BoxFit.cover,
                                            //   image: Image.asset(
                                            //     'assets/images/Capture_decran_2024-06-05_a_15.49.36.png',
                                            //   ).image,
                                            // ),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                          ),
                                          child: gflutter.GoogleMap(
                                            key: _mapKey,
                                            initialCameraPosition:
                                                gflutter.CameraPosition(
                                              target: _currentPositionG!,
                                              zoom: 12,
                                            ),
                                            polylines: polylines,
                                            markers: {
                                              gflutter.Marker(
                                                markerId:
                                                    gflutter.MarkerId('depart'),
                                                position: _currentPositionG!,
                                                icon: _startIcon ??
                                                    gflutter.BitmapDescriptor
                                                        .defaultMarker,
                                              ),
                                              gflutter.Marker(
                                                markerId: gflutter.MarkerId(
                                                    'arrivee'),
                                                position: _currentPositionA!,
                                                icon: _endIcon ??
                                                    gflutter.BitmapDescriptor
                                                        .defaultMarker,
                                              ),
                                            },
                                            onMapCreated: (controller) {
                                              _controllerg = controller;
                                              print(
                                                  "bouge $_currentPositionG $_currentPositionA");
                                              // Future.delayed(
                                              //     Duration(milliseconds: 300),
                                              //     () {
                                              // try {
                                              _moveCameraToFitBounds(
                                                  _currentPositionG!,
                                                  _currentPositionA!);
                                              // } catch (e) {
                                              //   print(
                                              //       "Erreur dans moveCamera: $e");
                                              // }
                                              // });
                                            },
                                            myLocationEnabled: true,
                                            zoomGesturesEnabled: true,
                                            scrollGesturesEnabled: true,
                                            rotateGesturesEnabled: true,
                                            tiltGesturesEnabled: true,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 300, 0, 0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 0),
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
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          5.0,
                                                                          0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .info_rounded,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 15.0,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Détails',
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
                                                                            .w500,
                                                                  ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            5.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          5.0,
                                                                          0.0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .camera_rounded,
                                                                        color: Color(
                                                                            0xFF7145D7),
                                                                        size:
                                                                            14.0,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      () {
                                                                        if (stackRideRequestRecord?.status ==
                                                                            'accepted') {
                                                                          return 'Accepté';
                                                                        } else if (stackRideRequestRecord?.status ==
                                                                            'arriving') {
                                                                          return 'En route';
                                                                        } else if (stackRideRequestRecord?.status ==
                                                                            'arrived') {
                                                                          return 'Arrivé';
                                                                        } else if (stackRideRequestRecord?.status ==
                                                                            'in_progress') {
                                                                          return 'En cours';
                                                                        } else {
                                                                          return 'completed';
                                                                        }
                                                                      }(),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Plus Jakarta Sans',
                                                                            color:
                                                                                Color(0xFF7145D7),
                                                                            fontSize:
                                                                                10.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        // Generated code for this IconButton Widget...
                                                        if ((stackRideRequestRecord?.status == 'accepted') ||
                                                            (stackRideRequestRecord
                                                                    ?.status ==
                                                                'arriving') ||
                                                            (stackRideRequestRecord
                                                                    ?.status ==
                                                                'in_progress'))
                                                          FlutterFlowIconButton(
                                                            borderColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            borderRadius: 20,
                                                            borderWidth: 1,
                                                            buttonSize: 40,
                                                            fillColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            icon: Icon(
                                                              Icons
                                                                  .navigation_sharp,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              size: 24,
                                                            ),
                                                            showLoadingIndicator:
                                                                true,
                                                            onPressed:
                                                                () async {
                                                              print(
                                                                  "==vari ${widget.idCourse}");
                                                              if (stackRideRequestRecord
                                                                      ?.status ==
                                                                  'arriving') {
                                                                context
                                                                    .pushNamed(
                                                                  'navigation',
                                                                  queryParameters:
                                                                      {
                                                                    'idCourse':
                                                                        serializeParam(
                                                                      widget!
                                                                          .idCourse,
                                                                      ParamType
                                                                          .int,
                                                                    ),
                                                                    'depart':
                                                                        serializeParam(
                                                                      <String,
                                                                          dynamic>{
                                                                        'display_name':
                                                                            stackRideRequestRecord?.startAddress,
                                                                        'longitude':
                                                                            getJsonField(
                                                                          FFAppState()
                                                                              .userPositionData,
                                                                          r'''$.longitude''',
                                                                        ),
                                                                        'latitude':
                                                                            getJsonField(
                                                                          FFAppState()
                                                                              .userPositionData,
                                                                          r'''$.latitude''',
                                                                        ),
                                                                      },
                                                                      ParamType
                                                                          .JSON,
                                                                    ),
                                                                    'arrivee':
                                                                        serializeParam(
                                                                      <String,
                                                                          dynamic>{
                                                                        'display_name':
                                                                            stackRideRequestRecord?.startAddress,
                                                                        'longitude':
                                                                            stackRideRequestRecord?.startLongitude,
                                                                        'latitude':
                                                                            stackRideRequestRecord?.startLatitude,
                                                                      },
                                                                      ParamType
                                                                          .JSON,
                                                                    ),
                                                                    'arrets':
                                                                        serializeParam(
                                                                      functions
                                                                          .parseAndConvertToJson(
                                                                              stackRideRequestRecord?.arretCoordonnee)
                                                                          ?.toList(),
                                                                      ParamType
                                                                          .JSON,
                                                                      isList:
                                                                          true,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              } else {
                                                                context
                                                                    .pushNamed(
                                                                  'navigation',
                                                                  queryParameters:
                                                                      {
                                                                    'idCourse':
                                                                        serializeParam(
                                                                      widget!
                                                                          .idCourse,
                                                                      ParamType
                                                                          .int,
                                                                    ),
                                                                    'depart':
                                                                        serializeParam(
                                                                      <String,
                                                                          dynamic>{
                                                                        'display_name':
                                                                            stackRideRequestRecord?.startAddress,
                                                                        'longitude':
                                                                            stackRideRequestRecord?.startLongitude,
                                                                        'latitude':
                                                                            stackRideRequestRecord?.startLatitude,
                                                                      },
                                                                      ParamType
                                                                          .JSON,
                                                                    ),
                                                                    'arrivee':
                                                                        serializeParam(
                                                                      <String,
                                                                          dynamic>{
                                                                        'display_name':
                                                                            stackRideRequestRecord?.endAddress,
                                                                        'longitude':
                                                                            stackRideRequestRecord?.endLongitude,
                                                                        'latitude':
                                                                            stackRideRequestRecord?.endLatitude,
                                                                      },
                                                                      ParamType
                                                                          .JSON,
                                                                    ),
                                                                    'arrets':
                                                                        serializeParam(
                                                                      functions
                                                                          .parseAndConvertToJson(
                                                                              stackRideRequestRecord?.arretCoordonnee)
                                                                          ?.toList(),
                                                                      ParamType
                                                                          .JSON,
                                                                      isList:
                                                                          true,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              }
                                                            },
                                                          )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Durée trajet',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Plus Jakarta Sans',
                                                                          color:
                                                                              Color(0xFF959595),
                                                                          fontSize:
                                                                              13.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      functions.formatDuration(
                                                                          stackRideRequestRecord!
                                                                              .duration),
                                                                      '0',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Plus Jakarta Sans',
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        10.0)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 1.0,
                                                          height: 20.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Distance trajet',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Plus Jakarta Sans',
                                                                          color:
                                                                              Color(0xFF959595),
                                                                          fontSize:
                                                                              13.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    '${stackRideRequestRecord?.distance?.toString()}Km',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Plus Jakarta Sans',
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        10.0)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 1.0,
                                                          height: 20.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Prix',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Plus Jakarta Sans',
                                                                          color:
                                                                              Color(0xFF959595),
                                                                          fontSize:
                                                                              13.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    '${stackRideRequestRecord?.montant?.toString()} F',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Plus Jakarta Sans',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).tertiary,
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        10.0)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          1.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    Divider(
                                                      thickness: 1.0,
                                                      color: Color(0xFFEBEEF2),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 5.0)),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  10.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        5.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons.info_sharp,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              size: 15.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Trajet',
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
                                                                          .w500,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(2.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          boxShadow: [
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
                                                                      20.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            10.0,
                                                                            0.0),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                blurRadius: 4.0,
                                                                                color: Color(0x33000000),
                                                                                offset: Offset(
                                                                                  0.0,
                                                                                  2.0,
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/bonhomme.png',
                                                                              width: 30.0,
                                                                              height: 30.0,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          stackRideRequestRecord
                                                                              ?.startAddress,
                                                                          '-',
                                                                        ).maybeHandleOverflow(
                                                                          maxChars:
                                                                              20,
                                                                          replacement:
                                                                              '…',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Plus Jakarta Sans',
                                                                              color: Color(0xFF7145D7),
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            10.0,
                                                                            0.0),
                                                                    child:
                                                                        InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor:
                                                                          Colors
                                                                              .transparent,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        await actions
                                                                            .mapRedirection(
                                                                          stackRideRequestRecord!
                                                                              .startLatitude,
                                                                          stackRideRequestRecord!
                                                                              .startLongitude,
                                                                        );
                                                                      },
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/ic_map_icon.png',
                                                                          width:
                                                                              20.0,
                                                                          height:
                                                                              20.0,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        10.0)),
                                                              ),
                                                              Divider(
                                                                thickness: 1.0,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Builder(
                                                                    builder:
                                                                        (context) {
                                                                      final lesArrets =
                                                                          functions.parseAndConvertToJson(stackRideRequestRecord?.arretCoordonnee)?.toList() ??
                                                                              [];
                                                                      return Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: List.generate(
                                                                            lesArrets.length,
                                                                            (lesArretsIndex) {
                                                                          final lesArretsItem =
                                                                              lesArrets[lesArretsIndex];
                                                                          return Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                                                                                      child: Icon(
                                                                                        Icons.drag_indicator_rounded,
                                                                                        color: Color(0xFFB8BBBE),
                                                                                        size: 18.0,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      getJsonField(
                                                                                        lesArretsItem,
                                                                                        r'''$.display_name''',
                                                                                      ).toString().maybeHandleOverflow(
                                                                                            maxChars: 20,
                                                                                            replacement: '…',
                                                                                          ),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Plus Jakarta Sans',
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            letterSpacing: 0.0,
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                                                                                child: InkWell(
                                                                                  splashColor: Colors.transparent,
                                                                                  focusColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  highlightColor: Colors.transparent,
                                                                                  onTap: () async {
                                                                                    await actions.mapRedirection(
                                                                                      getJsonField(
                                                                                        lesArretsItem,
                                                                                        r'''$.latitude''',
                                                                                      ),
                                                                                      getJsonField(
                                                                                        lesArretsItem,
                                                                                        r'''$.longitude''',
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                    child: Image.asset(
                                                                                      'assets/images/ic_map_icon.png',
                                                                                      width: 20.0,
                                                                                      height: 20.0,
                                                                                      fit: BoxFit.contain,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        }),
                                                                      );
                                                                    },
                                                                  ),
                                                                  Visibility(
                                                                    visible: widget.arret !=
                                                                            null &&
                                                                        widget.arret?.length !=
                                                                            0,
                                                                    child:
                                                                        Divider(
                                                                      thickness:
                                                                          1.0,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            10.0,
                                                                            0.0),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                blurRadius: 4.0,
                                                                                color: Color(0x33000000),
                                                                                offset: Offset(
                                                                                  0.0,
                                                                                  2.0,
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/orange.png',
                                                                              width: 30.0,
                                                                              height: 30.0,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          stackRideRequestRecord
                                                                              ?.endAddress,
                                                                          '-',
                                                                        ).maybeHandleOverflow(
                                                                          maxChars:
                                                                              20,
                                                                          replacement:
                                                                              '…',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Plus Jakarta Sans',
                                                                              color: FlutterFlowTheme.of(context).tertiary,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            10.0,
                                                                            0.0),
                                                                    child:
                                                                        InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor:
                                                                          Colors
                                                                              .transparent,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        await actions
                                                                            .mapRedirection(
                                                                          stackRideRequestRecord!
                                                                              .endLatitude,
                                                                          stackRideRequestRecord!
                                                                              .endLongitude,
                                                                        );
                                                                      },
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/ic_map_icon.png',
                                                                          width:
                                                                              20.0,
                                                                          height:
                                                                              20.0,
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        10.0)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 10.0)),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 1.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 50.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Generated code for this ConditionalBuilder Widget...
                                      Builder(
                                        builder: (context) {
                                          if (stackRideRequestRecord?.status ==
                                              'accepted') {
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 20, 0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  _model.apiResultc90 =
                                                      await ApisGoBabiGroup
                                                          .rideRequestUpdateCall
                                                          .call(
                                                    rideId:
                                                        stackRideRequestRecord
                                                            ?.id,
                                                    token: FFAppState().token,
                                                    status: 'arriving',
                                                  );
                                                  if ((_model.apiResultc90
                                                          ?.succeeded ??
                                                      true)) {
                                                    showSimpleNotification(
                                                        NotifBulleWidget(
                                                          titre: 'Gobabi',
                                                          content:
                                                              'Vous allez chercher le client',
                                                        ),
                                                        elevation: 0,
                                                        background:
                                                            Colors.transparent,
                                                        duration: Duration(
                                                            seconds: 2));

                                                    context.pushNamed(
                                                      'navigation',
                                                      queryParameters: {
                                                        'idCourse':
                                                            serializeParam(
                                                          widget!.idCourse,
                                                          ParamType.int,
                                                        ),
                                                        'depart':
                                                            serializeParam(
                                                          <String, dynamic>{
                                                            'display_name':
                                                                stackRideRequestRecord
                                                                    ?.startAddress,
                                                            'longitude':
                                                                getJsonField(
                                                              FFAppState()
                                                                  .userPositionData,
                                                              r'''$.longitude''',
                                                            ),
                                                            'latitude':
                                                                getJsonField(
                                                              FFAppState()
                                                                  .userPositionData,
                                                              r'''$.latitude''',
                                                            ),
                                                          },
                                                          ParamType.JSON,
                                                        ),
                                                        'arrivee':
                                                            serializeParam(
                                                          <String, dynamic>{
                                                            'display_name':
                                                                stackRideRequestRecord
                                                                    ?.startAddress,
                                                            'longitude':
                                                                stackRideRequestRecord
                                                                    ?.startLongitude,
                                                            'latitude':
                                                                stackRideRequestRecord
                                                                    ?.startLatitude,
                                                          },
                                                          ParamType.JSON,
                                                        ),
                                                        'arrets':
                                                            serializeParam(
                                                          functions
                                                              .parseAndConvertToJson(
                                                                  stackRideRequestRecord
                                                                      ?.arretCoordonnee)
                                                              ?.toList(),
                                                          ParamType.JSON,
                                                          isList: true,
                                                        ),
                                                      }.withoutNulls,
                                                    );
                                                  } else {
                                                    print(
                                                        "erreur ${_model.apiResultc90?.statusCode}");
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Une erreur est survenue veuillez réessayer',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                      ),
                                                    );
                                                  }
                                                  setState(() {});
                                                },
                                                text: 'Se mettre en route',
                                                options: FFButtonOptions(
                                                  width: double.infinity,
                                                  height: 50,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(24, 0, 24, 0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .tertiary,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            color: Colors.white,
                                                            letterSpacing: 0,
                                                          ),
                                                  elevation: 0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            );
                                          } else if (stackRideRequestRecord
                                                  ?.status ==
                                              'arriving') {
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 20, 0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  _model.apiResulti8j =
                                                      await ApisGoBabiGroup
                                                          .rideRequestUpdateCall
                                                          .call(
                                                    rideId:
                                                        stackRideRequestRecord
                                                            ?.id,
                                                    token: FFAppState().token,
                                                    status: 'arrived',
                                                  );
                                                  if ((_model.apiResulti8j
                                                          ?.succeeded ??
                                                      true)) {
                                                    showSimpleNotification(
                                                        NotifBulleWidget(
                                                          titre: 'Gobabi',
                                                          content:
                                                              'Vous êtes arrivé chez le client',
                                                        ),
                                                        elevation: 0,
                                                        background:
                                                            Colors.transparent,
                                                        duration: Duration(
                                                            seconds: 2));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Une erreur est survenue , veuillez réessayer',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                      ),
                                                    );
                                                  }
                                                  setState(() {});
                                                },
                                                text: 'Je suis arrivé',
                                                options: FFButtonOptions(
                                                  width: double.infinity,
                                                  height: 50,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(24, 0, 24, 0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            color: Colors.white,
                                                            letterSpacing: 0,
                                                          ),
                                                  elevation: 0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            );
                                          } else if (stackRideRequestRecord
                                                  ?.status ==
                                              'arrived') {
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 20, 0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  _model.apiResult5os =
                                                      await ApisGoBabiGroup
                                                          .rideRequestUpdateCall
                                                          .call(
                                                    rideId:
                                                        stackRideRequestRecord
                                                            ?.id,
                                                    token: FFAppState().token,
                                                    status: 'in_progress',
                                                  );
                                                  if ((_model.apiResult5os
                                                          ?.succeeded ??
                                                      true)) {
                                                    speakText(
                                                        'GoBabi vous souhaite la bienvenue . Veuillez attacher votre ceinture de sécurité , même a larrière du véhicule');

                                                    context.pushNamed(
                                                      'navigation',
                                                      queryParameters: {
                                                        'idCourse':
                                                            serializeParam(
                                                          widget!.idCourse,
                                                          ParamType.int,
                                                        ),
                                                        'depart':
                                                            serializeParam(
                                                          <String, dynamic>{
                                                            'display_name':
                                                                stackRideRequestRecord
                                                                    ?.startAddress,
                                                            'longitude':
                                                                stackRideRequestRecord
                                                                    ?.startLongitude,
                                                            'latitude':
                                                                stackRideRequestRecord
                                                                    ?.startLatitude,
                                                          },
                                                          ParamType.JSON,
                                                        ),
                                                        'idCourse':
                                                            serializeParam(
                                                          widget!.idCourse,
                                                          ParamType.int,
                                                        ),
                                                        'arrivee':
                                                            serializeParam(
                                                          <String, dynamic>{
                                                            'display_name':
                                                                stackRideRequestRecord
                                                                    ?.endAddress,
                                                            'longitude':
                                                                stackRideRequestRecord
                                                                    ?.endLongitude,
                                                            'latitude':
                                                                stackRideRequestRecord
                                                                    ?.endLatitude,
                                                          },
                                                          ParamType.JSON,
                                                        ),
                                                        'arrets':
                                                            serializeParam(
                                                          functions
                                                              .parseAndConvertToJson(
                                                                  stackRideRequestRecord
                                                                      ?.arretCoordonnee)
                                                              ?.toList(),
                                                          ParamType.JSON,
                                                          isList: true,
                                                        ),
                                                      }.withoutNulls,
                                                    );

                                                    showSimpleNotification(
                                                        NotifBulleWidget(
                                                          titre: 'Gobabi',
                                                          content:
                                                              'La course a débuté',
                                                        ),
                                                        elevation: 0,
                                                        background:
                                                            Colors.transparent,
                                                        duration: Duration(
                                                            seconds: 2));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Une erreur est survenue , veuillez réessayer',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 4000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                      ),
                                                    );
                                                  }
                                                  setState(() {});
                                                },
                                                text: 'Commencer la course',
                                                options: FFButtonOptions(
                                                  width: double.infinity,
                                                  height: 50,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(24, 0, 24, 0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
                                                  color: Color(0xFF5065ED),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            color: Colors.white,
                                                            letterSpacing: 0,
                                                          ),
                                                  elevation: 0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            );
                                          } else if (stackRideRequestRecord
                                                  ?.status ==
                                              'in_progress') {
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 20, 0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  var confirmDialogResponse =
                                                      await showDialog<bool>(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Confirmation'),
                                                                content: Text(
                                                                    'Êtes-vous sûrs de vouloir terminer la course ?'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext,
                                                                            false),
                                                                    child: Text(
                                                                        'Annuler'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext,
                                                                            true),
                                                                    child: Text(
                                                                        'Confirmer'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ) ??
                                                          false;
                                                  if (confirmDialogResponse) {
                                                    _model.apiResultc26 =
                                                        await ApisGoBabiGroup
                                                            .completeRideCall
                                                            .call(
                                                      token: FFAppState().token,
                                                      id: stackRideRequestRecord
                                                          ?.id,
                                                      serviceId:
                                                          stackRideRequestRecord
                                                              ?.serviceId,
                                                      endLatitude:
                                                          stackRideRequestRecord
                                                              ?.endLatitude
                                                              ?.toString(),
                                                      endLongitude:
                                                          stackRideRequestRecord
                                                              ?.endLongitude
                                                              ?.toString(),
                                                      endAddress:
                                                          stackRideRequestRecord
                                                              ?.endAddress,
                                                      distance:
                                                          stackRideRequestRecord
                                                              ?.distance
                                                              ?.toString(),
                                                    );
                                                    if ((_model.apiResultc26
                                                            ?.succeeded ??
                                                        true)) {
                                                      speakText(
                                                          'Vérifiez que vous n\'avez rien oublié à l\'arrière du véhicule. Go’babi vous remercie');
                                                      context.pushNamed(
                                                          'HomePage');
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Vous avez terminé la course',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                          backgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondary,
                                                        ),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Une erreur ${(_model.apiResultc26?.statusCode ?? 200).toString()} est survenue veuillez réessayer',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                          backgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .error,
                                                        ),
                                                      );
                                                    }
                                                    setState(() {});
                                                  } else {
                                                    // Navigator.pop(context);
                                                  }
                                                },
                                                text: 'Terminer la course',
                                                options: FFButtonOptions(
                                                  width: double.infinity,
                                                  height: 50,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(24, 0, 24, 0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
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
                                                            letterSpacing: 0,
                                                          ),
                                                  elevation: 0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              width: 100,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/core.errors.dart';
// import 'package:here_sdk/gestures.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:here_sdk/routing.dart';
// import 'package:here_sdk/search.dart';

import '/backend/api_requests/api_calls.dart';
import '/composants/moyen_paiement/moyen_paiement_widget.dart';
import '/composants/other_rider/other_rider_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'confirm_trajet_model.dart';
export 'confirm_trajet_model.dart';
// import 'package:here_sdk/animation.dart' as here;

import 'package:google_maps_flutter/google_maps_flutter.dart' as gflutter;
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'
    as ltln;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmTrajetWidget extends StatefulWidget {
  const ConfirmTrajetWidget({
    super.key,
    this.depart,
    this.arrivee,
    this.arrets,
    this.trajetInfo,
  });

  final dynamic depart;
  final dynamic arrivee;
  final List<dynamic>? arrets;
  final dynamic trajetInfo;

  @override
  State<ConfirmTrajetWidget> createState() => _ConfirmTrajetWidgetState();
}

class _ConfirmTrajetWidgetState extends State<ConfirmTrajetWidget> {
  late ConfirmTrajetModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  double departLat = 0.0;
  double departLon = 0.0;
  double arriveeLat = 0.0;
  double arriveeLon = 0.0;
  // HereMapController? hereMapCont;
  UniqueKey _key = UniqueKey();
  // late SearchEngine _onlineSearchEngine;
  // bool useOnlineSearchEngine = true;
  // List<MapPolyline> _mapPolylines = [];
  // List<MapMarker> _mapMarkers = [];

// VARIABLES GOOGLE //
  ltln.LatLng? _currentPositionG;
  ltln.LatLng? _currentPositionA;

  gflutter.BitmapDescriptor? _startIcon;
  gflutter.BitmapDescriptor? _endIcon;
  gflutter.GoogleMapController? _controllerg;
  Set<gflutter.Polyline> polylines = {};
  Key _mapKey = UniqueKey();

  //

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConfirmTrajetModel());
    // try {
    //   _onlineSearchEngine = SearchEngine();
    // } on InstantiationException {
    //   throw ("Initialization of SearchEngine failed.");
    // }

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

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.arrets != null && (widget.arrets)!.isNotEmpty) {
        _model.tabTrajet = widget.arrets!.toList().cast<dynamic>();
        _model.arreTs = widget.arrets!.toList().cast<dynamic>();
        setState(() {});
        _model.insertAtIndexInTabTrajet(0, widget.depart!);
        setState(() {});
        _model.addToTabTrajet(widget.arrivee!);
        setState(() {});
      } else {
        await actions.printer();
        _model.addToTabTrajet(widget.depart!);
        setState(() {});
        _model.addToTabTrajet(widget.arrivee!);
        setState(() {});
      }

      _model.resCalT = await actions.sendGetRequestWithParams(
        '${getJsonField(
          widget.depart,
          r'''$.latitude''',
        ).toString().toString()},${getJsonField(
          widget.depart,
          r'''$.longitude''',
        ).toString().toString()}',
        '${getJsonField(
          widget.arrivee,
          r'''$.latitude''',
        ).toString().toString()},${getJsonField(
          widget.arrivee,
          r'''$.longitude''',
        ).toString().toString()}',
        functions.formattedCord(widget.arrets?.toList()).toList(),
        FFAppConstants.hereMapApiKey,
        'summary',
      );
      _model.resCalQ = _model.resCalT!.toList().cast<dynamic>();
      setState(() {});
      _model.apiRes3 = await ApisGoBabiGroup.estimatePriceWithDistanceCall.call(
        distance: functions
            .distanceAndDuration(_model.resCalT!.toList())
            .first
            .toString(),
      );

      if ((_model.apiRes3?.succeeded ?? true)) {
        _model.laRep = (_model.apiRes3?.jsonBody ?? '');
        _model.laRepPrem =
            ApisGoBabiGroup.estimatePriceWithDistanceCall.premierService(
          (_model.apiRes3?.jsonBody ?? ''),
        );
        _model.laRepDeux =
            ApisGoBabiGroup.estimatePriceWithDistanceCall.deuxiemeService(
          (_model.apiRes3?.jsonBody ?? ''),
        );
        setState(() {});
        _model.charge = false;
        _model.services = _model.laRep!.toList().cast<dynamic>();
        setState(() {});
        _model.choixService = _model.laRepPrem;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Une erreur ${_model.apiRes3?.statusCode} est survenue , veuillez réessayer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    polylines.clear();
    _controllerg?.dispose();
    _model.dispose();

    super.dispose();
  }

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

  //   _loadMapScene(hereMapController);
  //   // hereMapController.mapScene.enableFeatures(
  //   //     {MapFeatures.trafficFlow: MapFeatureModes.trafficFlowWithFreeFlow});

  //   addRoute(hereMapController, GeoCoordinates(departLat, departLon),
  //       GeoCoordinates(arriveeLat, arriveeLon));
  //   _cameraStateListener(hereMapController);
  // }

  // void _loadMapScene(HereMapController hereMapController) {
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
  // }

  // MONTRE LE TRAJET SUR LA CARTE

//   Future<void> addRoute(HereMapController hereMapController,
//       GeoCoordinates startPoint, GeoCoordinates endPoint) async {
//     RoutingEngine _routingEngine = RoutingEngine();
//     _clearRouteAndMarkers(hereMapController);

//     Waypoint startWaypoint = Waypoint.withDefaults(startPoint);
//     Waypoint arret1Waypoint;
//     Waypoint endWaypoint = Waypoint.withDefaults(endPoint);
//     List<Waypoint> waypoints = [];

// // ajout depart
//     waypoints.add(startWaypoint);
//     _addMapMarker(hereMapController, startPoint, "assets/images/bonhomme.png");
// //

// // ajout arrets
//     if (_model.arreTs != null && _model.arreTs?.length != 0) {
//       for (int i = 0; i < _model.arreTs!.length; i++) {
//         GeoCoordinates arretGeo = GeoCoordinates(
//             getJsonField(
//               _model.arreTs![i],
//               r'''$.latitude''',
//             ),
//             getJsonField(
//               _model.arreTs![i],
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

//   void _clearRouteAndMarkers(HereMapController hereMapController) {
//     for (var mapPolyline in _mapPolylines) {
//       hereMapController.mapScene.removeMapPolyline(mapPolyline);
//     }
//     _mapPolylines.clear();

//     for (var mapMarker in _mapMarkers) {
//       hereMapController.mapScene.removeMapMarker(mapMarker);
//     }
//     _mapMarkers.clear();
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
//     _mapMarkers.add(mapMarker);
//   }

//   void _logRouteSectionDetails(route) {
//     DateFormat dateFormat = DateFormat().add_Hm();
//     var total = 0;
//     var totalDuration = 0;
//     for (int i = 0; i < route.sections.length; i++) {
//       Section section = route.sections.elementAt(i);

//       print("Route Section : " + (i + 1).toString());
//       print("Route Section Departure Time : " +
//           dateFormat.format(section.departureLocationTime!.localTime));
//       print("Route Section Arrival Time : " +
//           dateFormat.format(section.arrivalLocationTime!.localTime));
//       print(
//           "Route Section length : " + section.lengthInMeters.toString() + " m");
//       print("Route Section duration : " +
//           section.duration.inSeconds.toString() +
//           " s");

//       total += section.lengthInMeters;
//       totalDuration += section.duration.inSeconds;
//     }
//     print('Route total ${total / 1000}');
//     print('duration total $totalDuration');
//     // setState(() {
//     //   _model.duration = totalDuration;
//     //   _model.distance = total / 1000;
//     // });

//     // estimatePrice();
//   }

//   void _cameraStateListener(HereMapController _hereMapController) {
//     _hereMapController.gestures.panListener = PanListener(
//         (GestureState gestureState, Point2D ledeuxd, Point2D ledeux,
//             double doub) {
//       if (gestureState == GestureState.begin) {
//         // Get the coordinates at the center of the map
//         GeoCoordinates centerCoordinates =
//             _hereMapController.camera.state.targetCoordinates;
//         print(
//             'Center coordinates: ${centerCoordinates.latitude}, ${centerCoordinates.longitude}');
//       }
//       if (gestureState == GestureState.end) {
//         GeoCoordinates centerCoordinates =
//             _hereMapController.camera.state.targetCoordinates;
//         print(
//             'Center coordinates: ${centerCoordinates.latitude}, ${centerCoordinates.longitude}');
//         // _getAddressForCoordinates(centerCoordinates);
//       }
//     });
//   }

//

  int roundUpToNearestHundred(double value) {
    return ((value / 100).ceil() * 100).toInt();
  }

  // void _resetMap() {
  //   if (hereMapCont != null) {
  //     _clearRouteAndMarkers(hereMapCont!);
  //     _onMapCreated(hereMapCont!);
  //   }
  // }

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
          automaticallyImplyLeading: true,
          title: Text(
            'Confirmation du trajet',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 80.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 250.0,
                                child: 
                                gflutter.GoogleMap(
                                  key: _mapKey,
                                  initialCameraPosition:
                                      gflutter.CameraPosition(
                                    target: _currentPositionG!,
                                    zoom: 12,
                                  ),
                                  polylines: polylines,
                                  markers: {
                                    gflutter.Marker(
                                      markerId: gflutter.MarkerId('depart'),
                                      position: _currentPositionG!,
                                      icon: _startIcon ??
                                          gflutter
                                              .BitmapDescriptor.defaultMarker,
                                    ),
                                    gflutter.Marker(
                                      markerId: gflutter.MarkerId('arrivee'),
                                      position: _currentPositionA!,
                                      icon: _endIcon ??
                                          gflutter
                                              .BitmapDescriptor.defaultMarker,
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
                                        _currentPositionG!, _currentPositionA!);
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
                               
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  // image: DecorationImage(
                                  //   fit: BoxFit.cover,
                                  //   image: Image.asset(
                                  //     'assets/images/Capture_decran_2024-06-05_a_15.49.36.png',
                                  //   ).image,
                                  // ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                              ),

                              // Generated code for this Row Widget...
                              // Generated code for this Row Widget...
                              if (_model.charge == false)
                                Builder(
                                  builder: (context) {
                                    final service =
                                        _model.laRep?.toList() ?? [];
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: List.generate(service.length,
                                            (serviceIndex) {
                                          final serviceItem =
                                              service[serviceIndex];
                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 10, 0, 10),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                _model.choixService =
                                                    serviceItem;
                                                safeSetState(() {});
                                              },
                                              child: Container(
                                                width: 110,
                                                decoration: BoxDecoration(
                                                  color: getJsonField(
                                                            serviceItem,
                                                            r'''$.name''',
                                                          ) ==
                                                          getJsonField(
                                                            _model.choixService,
                                                            r'''$.name''',
                                                          )
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: Image.asset(
                                                              'assets/images/2237829n.png',
                                                              width: 100,
                                                              height: 60,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child:
                                                                Image.network(
                                                              getJsonField(
                                                                serviceItem,
                                                                r'''$.image''',
                                                              ).toString(),
                                                              width: 100,
                                                              height: 60,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        getJsonField(
                                                          serviceItem,
                                                          r'''$.name''',
                                                        )
                                                            .toString()
                                                            .toUpperCase(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  color: getJsonField(
                                                                            serviceItem,
                                                                            r'''$.name''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            _model.choixService,
                                                                            r'''$.name''',
                                                                          )
                                                                      ? FlutterFlowTheme.of(context).secondaryBackground
                                                                      : FlutterFlowTheme.of(context).primaryText,
                                                                  fontSize: 10,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                      Text(
                                                        '${getJsonField(
                                                          serviceItem,
                                                          r'''$.result''',
                                                        ).toString()} FCFA',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  color: getJsonField(
                                                                            serviceItem,
                                                                            r'''$.name''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            _model.choixService,
                                                                            r'''$.name''',
                                                                          )
                                                                      ? FlutterFlowTheme.of(context).primaryBackground
                                                                      : FlutterFlowTheme.of(context).tertiary,
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 5)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).divide(SizedBox(width: 10)),
                                      ),
                                    );
                                  },
                                ),

                              // Generated code for this Row Widget...
                              if (_model.charge == true)
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Container(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          height: 120,
                                          child: custom_widgets.LeShimmer(
                                            width: 100,
                                            height: 120,
                                            radius: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Container(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          height: 120,
                                          child: custom_widgets.LeShimmer(
                                            width: 100,
                                            height: 120,
                                            radius: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Container(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          height: 120,
                                          child: custom_widgets.LeShimmer(
                                            width: 100,
                                            height: 120,
                                            radius: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 20)),
                                ),
                              Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
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
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                              'creationTrajet',
                                              queryParameters: {
                                                'depart': serializeParam(
                                                  widget.depart,
                                                  ParamType.JSON,
                                                ),
                                                'arrivee': serializeParam(
                                                  widget.arrivee,
                                                  ParamType.JSON,
                                                ),
                                                'arrets': serializeParam(
                                                  _model.arreTs,
                                                  ParamType.JSON,
                                                  isList: true,
                                                ),
                                                'prevInterface': serializeParam(
                                                  'confirmTrajet',
                                                  ParamType.String,
                                                ),
                                                'focus': serializeParam(
                                                  'depart',
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                              extra: <String, dynamic>{
                                                kTransitionInfoKey:
                                                    TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType
                                                          .leftToRight,
                                                ),
                                              },
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                10.0, 0.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
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
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/bonhomme.png',
                                                          width: 30.0,
                                                          height: 30.0,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    getJsonField(
                                                      widget.depart,
                                                      r'''$.display_name''',
                                                    )
                                                        .toString()
                                                        .maybeHandleOverflow(
                                                          maxChars: 24,
                                                          replacement: '…',
                                                        ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          color:
                                                              Color(0xFF7145D7),
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 10.0)),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1.0,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Builder(
                                              builder: (context) {
                                                final lesArrets =
                                                    _model.arreTs.toList();
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: List.generate(
                                                      lesArrets.length,
                                                      (lesArretsIndex) {
                                                    final lesArretsItem =
                                                        lesArrets[
                                                            lesArretsIndex];
                                                    return Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () async {
                                                              context.pushNamed(
                                                                'creationArretTrajet',
                                                                queryParameters:
                                                                    {
                                                                  'depart':
                                                                      serializeParam(
                                                                    widget
                                                                        .depart,
                                                                    ParamType
                                                                        .JSON,
                                                                  ),
                                                                  'arrivee':
                                                                      serializeParam(
                                                                    widget
                                                                        .arrivee,
                                                                    ParamType
                                                                        .JSON,
                                                                  ),
                                                                  'arrets':
                                                                      serializeParam(
                                                                    _model
                                                                        .arreTs,
                                                                    ParamType
                                                                        .JSON,
                                                                    isList:
                                                                        true,
                                                                  ),
                                                                  'prevInterface':
                                                                      serializeParam(
                                                                    'confirmTrajet',
                                                                    ParamType
                                                                        .String,
                                                                  ),
                                                                  'change':
                                                                      serializeParam(
                                                                    true,
                                                                    ParamType
                                                                        .bool,
                                                                  ),
                                                                  'index':
                                                                      serializeParam(
                                                                    lesArretsIndex,
                                                                    ParamType
                                                                        .int,
                                                                  ),
                                                                }.withoutNulls,
                                                                extra: <String,
                                                                    dynamic>{
                                                                  kTransitionInfoKey:
                                                                      TransitionInfo(
                                                                    hasTransition:
                                                                        true,
                                                                    transitionType:
                                                                        PageTransitionType
                                                                            .leftToRight,
                                                                  ),
                                                                },
                                                              );
                                                            },
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                          10.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            10.0,
                                                                            0.0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .drag_indicator_rounded,
                                                                          color:
                                                                              Color(0xFFB8BBBE),
                                                                          size:
                                                                              18.0,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${lesArretsIndex.toString()} - ${getJsonField(
                                                                          lesArretsItem,
                                                                          r'''$.display_name''',
                                                                        ).toString()}'
                                                                            .maybeHandleOverflow(
                                                                          maxChars:
                                                                              20,
                                                                          replacement:
                                                                              '…',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Plus Jakarta Sans',
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        // Generated code for this IconButton Widget...
                                                        FlutterFlowIconButton(
                                                          borderColor: Colors
                                                              .transparent,
                                                          borderRadius: 20,
                                                          borderWidth: 1,
                                                          buttonSize: 40,
                                                          icon: Icon(
                                                            Icons
                                                                .remove_circle_outlined,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            size: 24,
                                                          ),
                                                          showLoadingIndicator:
                                                              true,
                                                          onPressed: () async {
                                                            _model.removeAtIndexFromArreTs(
                                                                lesArretsIndex);
                                                            setState(() {});
                                                            _model.resCalT2 =
                                                                await actions
                                                                    .sendGetRequestWithParams(
                                                              '${getJsonField(
                                                                widget.depart,
                                                                r'''$.latitude''',
                                                              ).toString()},${getJsonField(
                                                                widget.depart,
                                                                r'''$.longitude''',
                                                              ).toString()}',
                                                              '${getJsonField(
                                                                widget.arrivee,
                                                                r'''$.latitude''',
                                                              ).toString()},${getJsonField(
                                                                widget.arrivee,
                                                                r'''$.longitude''',
                                                              ).toString()}',
                                                              functions
                                                                  .formattedCord(
                                                                      _model
                                                                          .arreTs
                                                                          .toList())
                                                                  .toList(),
                                                              FFAppConstants
                                                                  .hereMapApiKey,
                                                              'summary',
                                                            );
                                                            _model.resCalQ = _model
                                                                .resCalT2!
                                                                .toList()
                                                                .cast<
                                                                    dynamic>();
                                                            setState(() {});
                                                            _model.apiRes32 =
                                                                await ApisGoBabiGroup
                                                                    .estimatePriceWithDistanceCall
                                                                    .call(
                                                              distance: functions
                                                                  .distanceAndDuration(_model
                                                                      .resCalT2!
                                                                      .toList())
                                                                  .first
                                                                  .toString(),
                                                            );
                                                            if ((_model.apiRes32
                                                                    ?.succeeded ??
                                                                true)) {
                                                              _model
                                                                  .laRep = (_model
                                                                      .apiRes32
                                                                      ?.jsonBody ??
                                                                  '');
                                                              _model.laRepPrem =
                                                                  ApisGoBabiGroup
                                                                      .estimatePriceWithDistanceCall
                                                                      .premierService(
                                                                (_model.apiRes32
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              );
                                                              _model.laRepDeux =
                                                                  ApisGoBabiGroup
                                                                      .estimatePriceWithDistanceCall
                                                                      .deuxiemeService(
                                                                (_model.apiRes32
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              );
                                                              setState(() {});
                                                              _model.charge =
                                                                  false;
                                                              _model.services =
                                                                  _model.laRep!
                                                                      .toList()
                                                                      .cast<
                                                                          dynamic>();
                                                              setState(() {});
                                                              _model.choixService =
                                                                  _model
                                                                      .laRepPrem;
                                                              // _resetMap();
                                                              setState(() {});
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    'Une erreur est survenue , veuillez réessayer',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          15,
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
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  'creationArretTrajet',
                                                  queryParameters: {
                                                    'depart': serializeParam(
                                                      widget.depart,
                                                      ParamType.JSON,
                                                    ),
                                                    'arrivee': serializeParam(
                                                      widget.arrivee,
                                                      ParamType.JSON,
                                                    ),
                                                    'arrets': serializeParam(
                                                      _model.arreTs,
                                                      ParamType.JSON,
                                                      isList: true,
                                                    ),
                                                    'prevInterface':
                                                        serializeParam(
                                                      'confirmTrajet',
                                                      ParamType.String,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey:
                                                        TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType:
                                                          PageTransitionType
                                                              .leftToRight,
                                                    ),
                                                  },
                                                );
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 10.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Icon(
                                                            Icons.add_sharp,
                                                            color: Color(
                                                                0xFFB8BBBE),
                                                            size: 18.0,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Ajouter un arret',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
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
                                            Divider(
                                              thickness: 1.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                              'creationTrajet',
                                              queryParameters: {
                                                'depart': serializeParam(
                                                  widget.depart,
                                                  ParamType.JSON,
                                                ),
                                                'arrivee': serializeParam(
                                                  widget.arrivee,
                                                  ParamType.JSON,
                                                ),
                                                'arrets': serializeParam(
                                                  _model.arreTs,
                                                  ParamType.JSON,
                                                  isList: true,
                                                ),
                                                'prevInterface': serializeParam(
                                                  'confirmTrajet',
                                                  ParamType.String,
                                                ),
                                                'focus': serializeParam(
                                                  'arrivee',
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                              extra: <String, dynamic>{
                                                kTransitionInfoKey:
                                                    TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType
                                                          .leftToRight,
                                                ),
                                              },
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                10.0, 0.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
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
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/orange.png',
                                                          width: 30.0,
                                                          height: 30.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
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
                                                        getJsonField(
                                                          widget.arrivee,
                                                          r'''$.display_name''',
                                                        )
                                                            .toString()
                                                            .maybeHandleOverflow(
                                                              maxChars: 20,
                                                              replacement: '…',
                                                            ),
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                      Text(
                                                        'Distance totale : ${functions.distanceAndDuration(_model.resCalQ.toList()).first.toString()} Km',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color: Color(
                                                                  0xFF9B9B9B),
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 3.0)),
                                                  ),
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 10.0)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Moyen de paiement',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  color: Color(0xFF8E9296),
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                enableDrag: false,
                                                context: context,
                                                builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () => _model
                                                            .unfocusNode
                                                            .canRequestFocus
                                                        ? FocusScope.of(context)
                                                            .requestFocus(_model
                                                                .unfocusNode)
                                                        : FocusScope.of(context)
                                                            .unfocus(),
                                                    child: Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child:
                                                          MoyenPaiementWidget(),
                                                    ),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFF754CE3),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    if (valueOrDefault<bool>(
                                                      FFAppState()
                                                              .moyenPaiement ==
                                                          'cash',
                                                      true,
                                                    ))
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/Coins-amico.png',
                                                          width: 30.0,
                                                          height: 30.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    if (FFAppState()
                                                            .moyenPaiement ==
                                                        'wave')
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/wave.png',
                                                          width: 30.0,
                                                          height: 30.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    Text(
                                                      FFAppState()
                                                          .moyenPaiement,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            color: Colors.white,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(width: 5.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 20.0)),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 10.0)),
                                ),
                              ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Container(
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Divider(
                              thickness: 1.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        enableDrag: false,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () => _model
                                                    .unfocusNode.canRequestFocus
                                                ? FocusScope.of(context)
                                                    .requestFocus(
                                                        _model.unfocusNode)
                                                : FocusScope.of(context)
                                                    .unfocus(),
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: OtherRiderWidget(
                                                infosCourse: <String, dynamic>{
                                                  'service_id': getJsonField(
                                                    _model.choixService,
                                                    r'''$.id''',
                                                  ),
                                                  'datetime':
                                                      getCurrentTimestamp,
                                                  'start_latitude':
                                                      getJsonField(
                                                    widget.depart,
                                                    r'''$.latitude''',
                                                  ),
                                                  'start_longitude':
                                                      getJsonField(
                                                    widget.depart,
                                                    r'''$.longitude''',
                                                  ),
                                                  'start_address': getJsonField(
                                                    widget.depart,
                                                    r'''$.display_name''',
                                                  ),
                                                  'end_latitude': getJsonField(
                                                    widget.arrivee,
                                                    r'''$.latitude''',
                                                  ),
                                                  'end_longitude': getJsonField(
                                                    widget.arrivee,
                                                    r'''$.longitude''',
                                                  ),
                                                  'end_address': getJsonField(
                                                    widget.arrivee,
                                                    r'''$.display_name''',
                                                  ),
                                                  'montant': getJsonField(
                                                    _model.choixService,
                                                    r'''$.result''',
                                                  ),
                                                  'status':
                                                      FFAppState().leStatus[3],
                                                  'is_ride_for_other':
                                                      FFAppState()
                                                          .otherDriverBol
                                                          .last,
                                                  'distance': _model.resCalT2 !=
                                                              null &&
                                                          (_model.resCalT2)!
                                                              .isNotEmpty
                                                      ? functions
                                                          .distanceAndDuration(
                                                              _model.resCalT2!
                                                                  .toList())
                                                          .first
                                                      : functions
                                                          .distanceAndDuration(
                                                              _model.resCalT!
                                                                  .toList())
                                                          .first,
                                                  'duration': _model.resCalT2 !=
                                                              null &&
                                                          (_model.resCalT2)!
                                                              .isNotEmpty
                                                      ? functions
                                                          .distanceAndDuration(
                                                              _model.resCalT2!
                                                                  .toList())
                                                          .last
                                                      : functions
                                                          .distanceAndDuration(
                                                              _model.resCalT!
                                                                  .toList())
                                                          .last,
                                                  'arret_coordonnee': functions
                                                      .transformJsonListToString(
                                                          widget.arrets
                                                              ?.toList()),
                                                  'token': FFAppState().token,
                                                  'driver_id': getJsonField(
                                                    FFAppState().userInfo,
                                                    r'''$.id''',
                                                  ),
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    text: 'Continuer',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 50.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: Color(0xFF7145D7),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                      elevation: 0.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 10.0)),
                            ),
                          ].divide(SizedBox(height: 10.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

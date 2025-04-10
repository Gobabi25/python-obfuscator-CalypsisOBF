// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/gestures.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:here_sdk/routing.dart';
// import 'package:here_sdk/search.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'map_reserv_model.dart';
export 'map_reserv_model.dart';
// import 'package:here_sdk/animation.dart' as here;

import 'package:google_maps_flutter/google_maps_flutter.dart' as gflutter;
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'
    as ltln;
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapReservWidget extends StatefulWidget {
  const MapReservWidget({
    super.key,
    this.depart,
    this.arrivee,
  });

  final dynamic depart;
  final dynamic arrivee;

  @override
  State<MapReservWidget> createState() => _MapReservWidgetState();
}

class _MapReservWidgetState extends State<MapReservWidget> {
  late MapReservModel _model;
  double departLat = 0.0;
  double departLon = 0.0;
  double arriveeLat = 0.0;
  double arriveeLon = 0.0;
  // HereMapController? hereMapCont;
  UniqueKey _key = UniqueKey();
  // late SearchEngine _onlineSearchEngine;
  bool useOnlineSearchEngine = true;
  // List<MapPolyline> _mapPolylines = [];

  // VARIABLES GOOGLE //
  ltln.LatLng? _currentPositionG;
  ltln.LatLng? _currentPositionA;

  gflutter.BitmapDescriptor? _startIcon;
  gflutter.BitmapDescriptor? _endIcon;
  gflutter.GoogleMapController? _controllerg;
  Set<gflutter.Polyline> polylines = {};
  Key _mapKey = UniqueKey();

  //

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    departLat = double.parse(getJsonField(
      widget.depart,
      r'''$.start_latitude''',
    ));

    departLon = double.parse(getJsonField(
      widget.depart,
      r'''$.start_longitude''',
    ));

    arriveeLat = double.parse(getJsonField(
      widget.arrivee,
      r'''$.end_latitude''',
    ));

    arriveeLon = double.parse(getJsonField(
      widget.arrivee,
      r'''$.end_longitude''',
    ));
    _currentPositionG = ltln.LatLng(departLat, departLon);
    _currentPositionA = ltln.LatLng(arriveeLat, arriveeLon);
    _loadCarIcon();
    drawRoute();
    _model = createModel(context, () => MapReservModel());
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
//   void _onMapCreated(HereMapController hereMapController) {
//     print("LA MAP======");
//     hereMapCont = hereMapController;
//     hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
//         (MapError? error) {
//       if (error != null) {
//         print('Map scene not loaded. MapError: ${error.toString()}');
//         return;
//       }

//       const double distanceToEarthInMeters = 3000;
//       MapMeasure mapMeasureZoom =
//           MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
//       hereMapController.camera.lookAtPointWithMeasure(
//           GeoCoordinates(FFAppState().userPosition!.latitude,
//               FFAppState().userPosition!.longitude),
//           mapMeasureZoom);
//     });

//     // hereMapController.mapScene.enableFeatures(
//     //     {MapFeatures.trafficFlow: MapFeatureModes.trafficFlowWithFreeFlow});

//     addRoute(hereMapController, GeoCoordinates(departLat, departLon),
//         GeoCoordinates(arriveeLat, arriveeLon));
//     _cameraStateListener(hereMapController);
//   }

//   // MONTRE LE TRAJET SUR LA CARTE

//   Future<void> addRoute(HereMapController hereMapController,
//       GeoCoordinates startPoint, GeoCoordinates endPoint) async {
//     RoutingEngine _routingEngine = RoutingEngine();

//     GeoCoordinates mePoint = GeoCoordinates(FFAppState().userPosition!.latitude,
//         FFAppState().userPosition!.longitude);

//     Waypoint startWaypoint = Waypoint.withDefaults(startPoint);
//     Waypoint myWaypoint = Waypoint.withDefaults(mePoint);
//     Waypoint arret1Waypoint;
//     Waypoint endWaypoint = Waypoint.withDefaults(endPoint);
//     List<Waypoint> waypoints = [];

// // ajout depart
//     waypoints.add(startWaypoint);
//     _addMapMarker(hereMapController, startPoint, "assets/images/bonhomme.png");

//     waypoints.add(myWaypoint);
//     _addMapMarker(hereMapController, mePoint, "assets/images/ic_car.png");
// //

// // ajout arrets
//     // if (widget.arret != null && widget.arret?.length != 0) {
//     //   for (int i = 0; i < widget.arret!.length; i++) {
//     //     GeoCoordinates arretGeo = GeoCoordinates(
//     //         getJsonField(
//     //           widget.arret![i],
//     //           r'''$.latitude''',
//     //         ),
//     //         getJsonField(
//     //           widget.arret![i],
//     //           r'''$.longitude''',
//     //         ));
//     //     arret1Waypoint = Waypoint.withDefaults(arretGeo);
//     //     waypoints.add(arret1Waypoint);
//     //     _addMapMarker(hereMapController, arretGeo, "assets/images/stop.png");
//     //   }
//     // }
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
// //

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
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
                  Icons.arrow_back,
                  color: FlutterFlowTheme.of(context).info,
                  size: 24,
                ),
                onPressed: () async {
                  context.pushNamed('listeReservations');
                },
              ),
              Text(
                'Voir trajet',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 0.0,
                    ),
              ),
            ].divide(SizedBox(width: 5)),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: gflutter.GoogleMap(
            key: _mapKey,
            initialCameraPosition: gflutter.CameraPosition(
              target: _currentPositionG!,
              zoom: 12,
            ),
            polylines: polylines,
            markers: {
              gflutter.Marker(
                markerId: gflutter.MarkerId('depart'),
                position: _currentPositionG!,
                icon: _startIcon ?? gflutter.BitmapDescriptor.defaultMarker,
              ),
              gflutter.Marker(
                markerId: gflutter.MarkerId('arrivee'),
                position: _currentPositionA!,
                icon: _endIcon ?? gflutter.BitmapDescriptor.defaultMarker,
              ),
            },
            onMapCreated: (controller) {
              _controllerg = controller;
              print("bouge $_currentPositionG $_currentPositionA");
              // Future.delayed(
              //     Duration(milliseconds: 300),
              //     () {
              // try {
              _moveCameraToFitBounds(_currentPositionG!, _currentPositionA!);
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
            color: FlutterFlowTheme.of(context).secondaryBackground,
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: Image.asset(
            //     'assets/images/Capture_decran_2024-06-05_a_15.49.36.png',
            //   ).image,
            // ),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
            ),
          ),
        ),
      ),
    );
  }
}

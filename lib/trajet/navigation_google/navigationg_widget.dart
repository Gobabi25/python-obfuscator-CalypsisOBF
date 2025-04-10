import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NavigationG extends StatefulWidget {
  @override
  _NavigationGState createState() => _NavigationGState();
}

class _NavigationGState extends State<NavigationG> {
  GoogleMapController? _googleMapController;

  LatLng startLatLng = LatLng(6.5244, 3.3792); // Lagos, Nigeria
  LatLng endLatLng = LatLng(6.465422, 3.406448); // Ikeja, Nigeria
  Set<Polyline> polylines = {};

  Future<void> drawRoute() async {
    final String url =
        "https://router.project-osrm.org/route/v1/driving/${startLatLng.longitude},${startLatLng.latitude};${endLatLng.longitude},${endLatLng.latitude}?overview=full&geometries=geojson";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['routes'][0]['geometry']['coordinates'];

      List<LatLng> points =
          coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();

      setState(() {
        polylines.add(Polyline(
          polylineId: PolylineId("route"),
          points: points,
          color: Colors.blue,
          width: 5,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps + OSMR API")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: startLatLng,
          zoom: 12,
        ),
        onMapCreated: (controller) => _googleMapController = controller,
        polylines: polylines,
        markers: {
          Marker(markerId: MarkerId("start"), position: startLatLng),
          Marker(markerId: MarkerId("end"), position: endLatLng),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: drawRoute,
        child: Icon(Icons.directions),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: NavigationG()));

import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/composants/drawer_component/drawer_component_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.
  ///

  String statut = 'new_ride_requested';
  AppVersionRecord? version;

  bool enLigne = false;

  dynamic rideActuelle;

  dynamic user;
  dynamic choixMap;
  bool chargeRech = false;

  ///  State fields for stateful widgets in this page.
  ///
  ///

  double distanceChauffeurClient = 0.0;
  List<dynamic>? resDis;

  List<dynamic> zonesCommandes = [];
  void addToZonesCommandes(dynamic item) => zonesCommandes.add(item);
  void removeFromZonesCommandes(dynamic item) => zonesCommandes.remove(item);
  void removeAtIndexFromZonesCommandes(int index) =>
      zonesCommandes.removeAt(index);
  void insertAtIndexInZonesCommandes(int index, dynamic item) =>
      zonesCommandes.insert(index, item);
  void updateZonesCommandesAtIndex(int index, Function(dynamic) updateFn) =>
      zonesCommandes[index] = updateFn(zonesCommandes[index]);

  List<String> viaNull = [];
  void addToViaNull(String item) => viaNull.add(item);
  void removeFromViaNull(String item) => viaNull.remove(item);
  void removeAtIndexFromViaNull(int index) => viaNull.removeAt(index);
  void insertAtIndexInViaNull(int index, String item) =>
      viaNull.insert(index, item);
  void updateViaNullAtIndex(int index, Function(String) updateFn) =>
      viaNull[index] = updateFn(viaNull[index]);

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (current ride request)] action in HomePage widget.
  ApiCallResponse? laRideReq;
  ApiCallResponse? laRideReq2;
  ApiCallResponse? apiResulteyo;
  ApiCallResponse? apiResultsh1;
  // Stores action output result for [Backend Call - API (wallet check)] action in HomePage widget.
  ApiCallResponse? apiResultmze;
  ApiCallResponse? apiResulthfz;
  ApiCallResponse? apiResultkzc;
  // State field(s) for Switch widget.
  bool? switchValue;
  // Stores action output result for [Backend Call - API (update status)] action in Switch widget.
  ApiCallResponse? apiResulti97;
  ApiCallResponse? apiResulti97a;
  ApiCallResponse? apiResulti97z;
  ApiCallResponse? apiResulti97c;
  ApiCallResponse? apiResulti97e;
  ApiCallResponse? apiResulti97d;
  ApiCallResponse? apiResulti97f;
  // Stores action output result for [Backend Call - API (save version)] action in pageAccueil widget.
  ApiCallResponse? apiResultnnv;
  // Stores action output result for [Backend Call - API (save connexion)] action in pageAccueil widget.
  ApiCallResponse? apiResultumj;
  // Stores action output result for [Backend Call - API (update status)] action in Switch widget.
  ApiCallResponse? apiResulti97Copy;
  List<UsersRecord>? stackPreviousSnapshot;
  AudioPlayer? soundPlayer;
  // Stores action output result for [Backend Call - API (ride request respond)] action in Button widget.
  ApiCallResponse? apiResultu8g;
  ApiCallResponse? resGeo;
  ApiCallResponse? resChangePosition;
  // Model for drawerComponent component.
  late DrawerComponentModel drawerComponentModel;

  List<RideRequestRecord>? containerPreviousSnapshot;

  String enattente = 'new_booking_request';

  @override
  void initState(BuildContext context) {
    drawerComponentModel = createModel(context, () => DrawerComponentModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    drawerComponentModel.dispose();
  }
}

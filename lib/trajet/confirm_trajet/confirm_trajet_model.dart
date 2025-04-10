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
import 'confirm_trajet_widget.dart' show ConfirmTrajetWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConfirmTrajetModel extends FlutterFlowModel<ConfirmTrajetWidget> {
  ///  Local state fields for this page.

  List<dynamic> tabTrajet = [];
  void addToTabTrajet(dynamic item) => tabTrajet.add(item);
  void removeFromTabTrajet(dynamic item) => tabTrajet.remove(item);
  void removeAtIndexFromTabTrajet(int index) => tabTrajet.removeAt(index);
  void insertAtIndexInTabTrajet(int index, dynamic item) =>
      tabTrajet.insert(index, item);
  void updateTabTrajetAtIndex(int index, Function(dynamic) updateFn) =>
      tabTrajet[index] = updateFn(tabTrajet[index]);

  List<dynamic> arreTs = [];
  void addToArreTs(dynamic item) => arreTs.add(item);
  void removeFromArreTs(dynamic item) => arreTs.remove(item);
  void removeAtIndexFromArreTs(int index) => arreTs.removeAt(index);
  void insertAtIndexInArreTs(int index, dynamic item) =>
      arreTs.insert(index, item);
  void updateArreTsAtIndex(int index, Function(dynamic) updateFn) =>
      arreTs[index] = updateFn(arreTs[index]);

  dynamic laRep;

  dynamic laRepPrem;

  dynamic laRepDeux;

  List<dynamic> services = [];
  void addToServices(dynamic item) => services.add(item);
  void removeFromServices(dynamic item) => services.remove(item);
  void removeAtIndexFromServices(int index) => services.removeAt(index);
  void insertAtIndexInServices(int index, dynamic item) =>
      services.insert(index, item);
  void updateServicesAtIndex(int index, Function(dynamic) updateFn) =>
      services[index] = updateFn(services[index]);

  dynamic choixService;

  bool charge = false;

  double distance = 0.0;

  List<dynamic> resCalQ = [];
  void addToResCalQ(dynamic item) => resCalQ.add(item);
  void removeFromResCalQ(dynamic item) => resCalQ.remove(item);
  void removeAtIndexFromResCalQ(int index) => resCalQ.removeAt(index);
  void insertAtIndexInResCalQ(int index, dynamic item) =>
      resCalQ.insert(index, item);
  void updateResCalQAtIndex(int index, Function(dynamic) updateFn) =>
      resCalQ[index] = updateFn(resCalQ[index]);

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - sendGetRequestWithParams] action in confirmTrajet widget.
  List<dynamic>? resCalT;
  // Stores action output result for [Backend Call - API (Estimate price with distance)] action in confirmTrajet widget.
  ApiCallResponse? apiRes3;
  // Stores action output result for [Custom Action - sendGetRequestWithParams] action in IconButton widget.
  List<dynamic>? resCalT2;
  // Stores action output result for [Backend Call - API (Estimate price with distance)] action in IconButton widget.
  ApiCallResponse? apiRes32;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

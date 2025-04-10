import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'infos_trajet_widget.dart' show InfosTrajetWidget;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InfosTrajetModel extends FlutterFlowModel<InfosTrajetWidget> {
  ///  State fields for stateful widgets in this page.
  ///
  ///

  double? distanceChauffeurClient = 0.0;

  List<String> viaNull = [];
  void addToViaNull(String item) => viaNull.add(item);
  void removeFromViaNull(String item) => viaNull.remove(item);
  void removeAtIndexFromViaNull(int index) => viaNull.removeAt(index);
  void insertAtIndexInViaNull(int index, String item) =>
      viaNull.insert(index, item);
  void updateViaNullAtIndex(int index, Function(String) updateFn) =>
      viaNull[index] = updateFn(viaNull[index]);

  final unfocusNode = FocusNode();
  List<RideRequestRecord>? stackPreviousSnapshot;
  // Stores action output result for [Backend Call - API (ride request update)] action in Button widget.
  ApiCallResponse? apiResultc90;
  // Stores action output result for [Backend Call - API (ride request update)] action in Button widget.
  ApiCallResponse? apiResulti8j;
  // Stores action output result for [Backend Call - API (ride request update)] action in Button widget.
  ApiCallResponse? apiResult5os;
  // Stores action output result for [Backend Call - API (complete ride)] action in Button widget.
  ApiCallResponse? apiResultc26;

  List<dynamic>? resDis;
  RideRequestRecord? docSt;

  List<UsersRecord>? textPreviousSnapshot;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

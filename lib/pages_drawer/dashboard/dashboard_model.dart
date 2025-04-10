import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  Local state fields for this page.

  int coursesT = 0;

  int coursesA = 0;

  double note = 0.0;

  String montantG = '0';

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (stat courses montant)] action in dashboard widget.
  ApiCallResponse? apiResultktp;
  // Stores action output result for [Backend Call - API (stat courses montant)] action in dashboard widget.
  ApiCallResponse? apiResultn71;
  // Stores action output result for [Backend Call - API (stat rating)] action in dashboard widget.
  ApiCallResponse? apiResultvy7;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

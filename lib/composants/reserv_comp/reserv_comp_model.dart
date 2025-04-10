import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'reserv_comp_widget.dart' show ReservCompWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReservCompModel extends FlutterFlowModel<ReservCompWidget> {
  ///  Local state fields for this component.

  String newBooking = 'new_booking_request';

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (change statut reservation)] action in Button widget.
  ApiCallResponse? apiResults5v;
  // Stores action output result for [Backend Call - API (change statut reservation)] action in Button widget.
  ApiCallResponse? apiResults5vCopy;
  // Stores action output result for [Backend Call - API (detail reservation)] action in Button widget.
  ApiCallResponse? apiResult4g6;

  ApiCallResponse? apiResults5vCopy2;

  ApiCallResponse? apiResults5vCopy3;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

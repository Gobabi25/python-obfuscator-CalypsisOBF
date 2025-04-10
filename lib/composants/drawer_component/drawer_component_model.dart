import '/backend/api_requests/api_calls.dart';
import '/composants/back_session/back_session_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'drawer_component_widget.dart' show DrawerComponentWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerComponentModel extends FlutterFlowModel<DrawerComponentWidget> {
  ///  Local state fields for this component.

  bool see = false;

  ///  State fields for stateful widgets in this component.

  // Model for backSession component.
  late BackSessionModel backSessionModel;
  // Stores action output result for [Backend Call - API (delete user)] action in Row widget.
  ApiCallResponse? apiResultvei;
  ApiCallResponse? apiResulti97a;

  @override
  void initState(BuildContext context) {
    backSessionModel = createModel(context, () => BackSessionModel());
  }

  @override
  void dispose() {
    backSessionModel.dispose();
  }
}

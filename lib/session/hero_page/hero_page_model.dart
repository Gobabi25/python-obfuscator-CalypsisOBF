import '/composants/back_session/back_session_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'hero_page_widget.dart' show HeroPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HeroPageModel extends FlutterFlowModel<HeroPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for backSession component.
  late BackSessionModel backSessionModel;

  @override
  void initState(BuildContext context) {
    backSessionModel = createModel(context, () => BackSessionModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    backSessionModel.dispose();
  }
}

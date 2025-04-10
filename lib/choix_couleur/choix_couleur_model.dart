import '/components/couleurs_voiture_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'choix_couleur_widget.dart' show ChoixCouleurWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChoixCouleurModel extends FlutterFlowModel<ChoixCouleurWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for couleursVoiture component.
  late CouleursVoitureModel couleursVoitureModel;

  @override
  void initState(BuildContext context) {
    couleursVoitureModel = createModel(context, () => CouleursVoitureModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    couleursVoitureModel.dispose();
  }
}

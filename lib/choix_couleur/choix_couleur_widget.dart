import '/components/couleurs_voiture_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'choix_couleur_model.dart';
export 'choix_couleur_model.dart';

class ChoixCouleurWidget extends StatefulWidget {
  const ChoixCouleurWidget({super.key});

  @override
  State<ChoixCouleurWidget> createState() => _ChoixCouleurWidgetState();
}

class _ChoixCouleurWidgetState extends State<ChoixCouleurWidget> {
  late ChoixCouleurModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChoixCouleurModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: wrapWithModel(
          model: _model.couleursVoitureModel,
          updateCallback: () => setState(() {}),
          child: CouleursVoitureWidget(),
        ),
      ),
    );
  }
}

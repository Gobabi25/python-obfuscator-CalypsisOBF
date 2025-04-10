import 'package:go_babi_drive/backend/schema/img_car_record.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'couleurs_voiture_model.dart';
export 'couleurs_voiture_model.dart';

class CouleursVoitureWidget extends StatefulWidget {
  const CouleursVoitureWidget({super.key});

  @override
  State<CouleursVoitureWidget> createState() => _CouleursVoitureWidgetState();
}

class _CouleursVoitureWidgetState extends State<CouleursVoitureWidget> {
  late CouleursVoitureModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CouleursVoitureModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Selectionnez la couleur',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 18,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: FlutterFlowTheme.of(context).alternate,
            ),
            Expanded(
              child: StreamBuilder<List<ImgCarRecord>>(
                stream: queryImgCarRecord(),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    );
                  }
                  List<ImgCarRecord> gridViewImgCarRecordList = snapshot.data!;
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    scrollDirection: Axis.vertical,
                    itemCount: gridViewImgCarRecordList.length,
                    itemBuilder: (context, gridViewIndex) {
                      final gridViewImgCarRecord =
                          gridViewImgCarRecordList[gridViewIndex];
                      return InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.choixCouleur = gridViewImgCarRecord.couleur;
                          _model.choixImg = gridViewImgCarRecord.image;
                          setState(() {});
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: colorFromCssString(
                              gridViewImgCarRecord.couleur,
                              defaultColor: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: _model.choixCouleur ==
                                      gridViewImgCarRecord.couleur
                                  ? FlutterFlowTheme.of(context).tertiary
                                  : FlutterFlowTheme.of(context).alternate,
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _model.choixImg,
                width: 150,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            FFButtonWidget(
              onPressed: () async {
                FFAppState().choixImage = _model.choixImg;
                FFAppState().choixCouleur = _model.choixCouleur;
                setState(() {});
                Navigator.pop(context);
              },
              text: 'Valider',
              options: FFButtonOptions(
                width: double.infinity,
                height: 40,
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                elevation: 3,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ].divide(SizedBox(height: 10)),
        ),
      ),
    );
  }
}

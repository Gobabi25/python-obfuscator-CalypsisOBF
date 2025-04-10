import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reserv_comp_model.dart';
export 'reserv_comp_model.dart';

class ReservCompWidget extends StatefulWidget {
  const ReservCompWidget({
    super.key,
    this.reservInfo,
    this.status,
    bool? dejaEnCourse,
  }) : this.dejaEnCourse = dejaEnCourse ?? false;

  final dynamic reservInfo;
  final String? status;
  final bool dejaEnCourse;

  @override
  State<ReservCompWidget> createState() => _ReservCompWidgetState();
}

class _ReservCompWidgetState extends State<ReservCompWidget> {
  late ReservCompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    print("==LA RESERV ${getJsonField(
      widget!.reservInfo,
      r'''$.id''',
    )}");
    _model = createModel(context, () => ReservCompModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: double.infinity,
      // height: 290.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(
              0.0,
              2.0,
            ),
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10.0, 30.0, 10.0, 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget!.status == 'new_booking_request')
              Container(
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FFButtonWidget(
                      onPressed: () async {
                        _model.apiResults5v = await ApisGoBabiGroup
                            .changeStatutReservationCall
                            .call(
                          id: getJsonField(
                            widget!.reservInfo,
                            r'''$.id''',
                          ),
                          driverId: getJsonField(
                            FFAppState().userInfo,
                            r'''$.id''',
                          ),
                          statuts: 'accepted',
                          token: FFAppState().token,
                        );

                        if ((_model.apiResults5v?.succeeded ?? true)) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Vous avez pris en charge la réservation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).success,
                            ),
                          );
                          if (Navigator.of(context).canPop()) {
                            context.pop();
                          }
                          context.pushNamed(
                            'listeReservations',
                            queryParameters: {
                              'ind': serializeParam(
                                1,
                                ParamType.int,
                              ),
                            }.withoutNulls,
                          );
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Erreur lors de l\'acceptation de la réservation , veuillez réessayer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).error,
                            ),
                          );
                        }

                        setState(() {});
                      },
                      text: 'Accepter la réservation',
                      icon: Icon(
                        Icons.check_rounded,
                        size: 20.0,
                      ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                                fontFamily: 'Plus Jakarta Sans',
                                color: FlutterFlowTheme.of(context).success,
                                letterSpacing: 0.0,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ],
                ),
              ),
            if ((widget!.status == 'accepted') &&
                (functions.isToday(getJsonField(
                      widget!.reservInfo,
                      r'''$.date''',
                    ).toString()) ==
                    true) &&
                (widget!.dejaEnCourse == false))
              Container(
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FFButtonWidget(
                      onPressed: () async {
                        _model.apiResults5vCopy = await ApisGoBabiGroup
                            .changeStatutReservationCall
                            .call(
                          id: getJsonField(
                            widget!.reservInfo,
                            r'''$.id''',
                          ),
                          driverId: getJsonField(
                            FFAppState().userInfo,
                            r'''$.id''',
                          ),
                          statuts: 'arriving',
                          token: FFAppState().token,
                        );

                        if ((_model.apiResults5vCopy?.succeeded ?? true)) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Vous avez débuté la réservation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).success,
                            ),
                          );

                          print("INFOS RESERVATION=====");
                          print(
                              "INFOS RESERVATION=====${_model.apiResults5vCopy?.jsonBody.toString()}");

                          context.pushNamed(
                            'infosTrajet',
                            queryParameters: {
                              'idCourse': serializeParam(
                                getJsonField(
                                  (_model.apiResults5vCopy?.jsonBody ?? ''),
                                  r'''$.ride_request.id''',
                                ),
                                ParamType.int,
                              ),
                              'depart': serializeParam(
                                <String, dynamic>{
                                  'latitude': double.parse(getJsonField(
                                    (_model.apiResults5vCopy?.jsonBody ?? ''),
                                    r'''$.ride_request.start_latitude''',
                                  )),
                                  'longitude': double.parse(getJsonField(
                                    (_model.apiResults5vCopy?.jsonBody ?? ''),
                                    r'''$.ride_request.start_longitude''',
                                  )),
                                  'display_name': getJsonField(
                                    (_model.apiResults5vCopy?.jsonBody ?? ''),
                                    r'''$.ride_request.start_address''',
                                  ),
                                },
                                ParamType.JSON,
                              ),
                              'arrivee': serializeParam(
                                <String, dynamic>{
                                  'latitude': double.parse(getJsonField(
                                    (_model.apiResults5vCopy?.jsonBody ?? ''),
                                    r'''$.ride_request.end_latitude''',
                                  )),
                                  'longitude': double.parse(getJsonField(
                                    (_model.apiResults5vCopy?.jsonBody ?? ''),
                                    r'''$.ride_request.end_longitude''',
                                  )),
                                  'display_name': getJsonField(
                                    (_model.apiResults5vCopy?.jsonBody ?? ''),
                                    r'''$.ride_request.end_address''',
                                  ),
                                },
                                ParamType.JSON,
                              ),
                              'arret': serializeParam(
                                functions.parseAndConvertToJson(''),
                                ParamType.JSON,
                                isList: true,
                              ),
                            }.withoutNulls,
                          );
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Erreur lors du démarrage de la réservation , veuillez réessayer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).error,
                            ),
                          );
                        }

                        setState(() {});
                      },
                      text: 'Commencer la réservation',
                      icon: Icon(
                        Icons.start_rounded,
                        size: 20.0,
                      ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                                fontFamily: 'Plus Jakarta Sans',
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ],
                ),
              ),
            if (widget!.status == 'accepted')
              Container(
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FFButtonWidget(
                      onPressed: () async {
                        _model.apiResults5vCopy2 =
                            await ApisGoBabiGroup.desisterReservationCall.call(
                          id: getJsonField(
                            widget!.reservInfo,
                            r'''$.id''',
                          ),
                          token: FFAppState().token,
                          status: 'canceled',
                          driverId: getJsonField(
                            FFAppState().userInfo,
                            r'''$.id''',
                          ),
                          cancelBy: 'driver',
                        );

                        if ((_model.apiResults5vCopy2?.succeeded ?? true)) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Vous avez désisté , vous n\'êtes plus en charge de la réservation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).success,
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Erreur lors du désistement de la réservation , veuillez réessayer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).error,
                            ),
                          );
                        }

                        setState(() {});
                      },
                      text: 'Désister',
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: 20.0,
                      ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                                fontFamily: 'Plus Jakarta Sans',
                                color: FlutterFlowTheme.of(context).error,
                                letterSpacing: 0.0,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ],
                ),
              ),
            // Generated code for this Container Widget...

            Container(
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FFButtonWidget(
                    onPressed: () async {
                      _model.apiResults5vCopy3 =
                          await ApisGoBabiGroup.detailReservationCall.call(
                        id: getJsonField(
                          widget!.reservInfo,
                          r'''$.id''',
                        ),
                        token: FFAppState().token,
                      );
                      if ((_model.apiResults5vCopy3?.succeeded ?? true)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                      context.pushNamed(
                        'mapReserv',
                        queryParameters: {
                          'depart': serializeParam(
                            <String, dynamic>{
                              'start_address': getJsonField(
                                (_model.apiResults5vCopy3?.jsonBody ?? ''),
                                r'''$.reservations[0].start_address''',
                              ),
                              'start_longitude': getJsonField(
                                (_model.apiResults5vCopy3?.jsonBody ?? ''),
                                r'''$.reservations[0].start_longitude''',
                              ),
                              'start_latitude': getJsonField(
                                (_model.apiResults5vCopy3?.jsonBody ?? ''),
                                r'''$.reservations[0].start_latitude''',
                              ),
                            },
                            ParamType.JSON,
                          ),
                          'arrivee': serializeParam(
                            <String, dynamic>{
                              'end_address': getJsonField(
                                (_model.apiResults5vCopy3?.jsonBody ?? ''),
                                r'''$.reservations[0].end_address''',
                              ),
                              'end_latitude': getJsonField(
                                (_model.apiResults5vCopy3?.jsonBody ?? ''),
                                r'''$.reservations[0].end_latitude''',
                              ),
                              'end_longitude': getJsonField(
                                (_model.apiResults5vCopy3?.jsonBody ?? ''),
                                r'''$.reservations[0].end_longitude''',
                              ),
                            },
                            ParamType.JSON,
                          ),
                        }.withoutNulls,
                      );
                      safeSetState(() {});
                    },
                    text: 'Voir le trajet',
                    icon: Icon(
                      Icons.location_on,
                      size: 15,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 40,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Color(0xFF3F4DFF),
                                fontSize: 20,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                      elevation: 0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FFButtonWidget(
                    onPressed: () async {
                      _model.apiResult4g6 =
                          await ApisGoBabiGroup.detailReservationCall.call(
                        id: getJsonField(
                          widget!.reservInfo,
                          r'''$.id''',
                        ),
                      );

                      if ((_model.apiResult4g6?.succeeded ?? true)) {
                        Navigator.pop(context);

                        context.pushNamed(
                          'infosReservation',
                          queryParameters: {
                            'reservation': serializeParam(
                              getJsonField(
                                (_model.apiResult4g6?.jsonBody ?? ''),
                                r'''$.reservations[0]''',
                              ),
                              ParamType.JSON,
                            ),
                            'dejaEnCourse': serializeParam(
                              widget!.dejaEnCourse,
                              ParamType.bool,
                            ),
                          }.withoutNulls,
                        );
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Erreur lors de la récupération des infos de la réservation veuillez réessayer',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                      }

                      setState(() {});
                    },
                    text: 'Infos réservation',
                    icon: Icon(
                      Icons.info_outlined,
                      size: 20.0,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                              fontFamily: 'Plus Jakarta Sans',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(),
            ),
          ].divide(SizedBox(height: 10.0)),
        ),
      ),
    );
  }
}

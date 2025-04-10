import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:go_babi_drive/backend/backend.dart';

import '/backend/api_requests/api_calls.dart';
import '/composants/reserv_comp/reserv_comp_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'research_reserv_model.dart';
export 'research_reserv_model.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;

class ResearchReservWidget extends StatefulWidget {
  const ResearchReservWidget({super.key});

  @override
  State<ResearchReservWidget> createState() => _ResearchReservWidgetState();
}

class _ResearchReservWidgetState extends State<ResearchReservWidget> {
  late ResearchReservModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResearchReservModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderColor: FlutterFlowTheme.of(context).primary,
                    borderRadius: 20.0,
                    borderWidth: 1.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).primary,
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      }
                      context.pushNamed('listeReservations');
                    },
                  ),
                  Text(
                    'Recherche',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: Colors.white,
                          fontSize: 22.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                ].divide(SizedBox(width: 5.0)),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderColor: FlutterFlowTheme.of(context).primary,
                    borderRadius: 20.0,
                    borderWidth: 1.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).primary,
                    icon: Icon(
                      Icons.location_searching,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      _model.butRecherche = 'localisation';
                      _model.charge = true;
                      setState(() {});
                      _model.apiResult55c =
                          await ApisGoBabiGroup.rechercherReservationCall.call(
                        longitude: getJsonField(
                          FFAppState().userPositionData,
                          r'''$.longitude''',
                        ).toString(),
                        latitude: getJsonField(
                          FFAppState().userPositionData,
                          r'''$.latitude''',
                        ).toString(),
                        page: '1',
                      );

                      if ((_model.apiResult55c?.succeeded ?? true)) {
                        _model.listeReservations =
                            ApisGoBabiGroup.rechercherReservationCall
                                .lesReserv(
                                  (_model.apiResult55c?.jsonBody ?? ''),
                                )!
                                .toList()
                                .cast<dynamic>();
                        _model.nbrPage =
                            ApisGoBabiGroup.rechercherReservationCall.nbrPages(
                          (_model.apiResult55c?.jsonBody ?? ''),
                        )!;
                        _model.charge = false;
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Erreur lors de la recherche , veuillez réessayer',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                      }
                      _model.charge = false;
                      setState(() {});
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: FlutterFlowTheme.of(context).primary,
                    borderRadius: 20.0,
                    borderWidth: 1.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).primary,
                    icon: Icon(
                      Icons.access_time,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      _model.butRecherche = 'heure';

                      setState(() {});

                      DatePicker.showTimePicker(context,
                          showTitleActions: true, showSecondsColumn: false,
                          // minTime: DateTime(2018, 3, 5),
                          // maxTime: DateTime(2019, 6, 7),
                          onChanged: (date) async {
                        _model.charge = true;
                        print('change $date');
                        setState(() {
                          _model.datePicked1 = date;
                        });
                        if (_model.datePicked1 != null) {
                          _model.heureSelect = _model.datePicked1;
                          setState(() {});
                          _model.apiResultf24 = await ApisGoBabiGroup
                              .rechercherReservationCall
                              .call(
                            time: functions.formatTimeString(
                                _model.datePicked1!.toString()),
                            page: '1',
                          );

                          if ((_model.apiResultf24?.succeeded ?? true)) {
                            _model.listeReservations =
                                ApisGoBabiGroup.rechercherReservationCall
                                    .lesReserv(
                                      (_model.apiResultf24?.jsonBody ?? ''),
                                    )!
                                    .toList()
                                    .cast<dynamic>();
                            _model.nbrPage = ApisGoBabiGroup
                                .rechercherReservationCall
                                .nbrPages(
                              (_model.apiResultf24?.jsonBody ?? ''),
                            )!;
                            _model.charge = false;
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erreur lors de la recherche , veuillez réessayer',
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
                        }
                        _model.charge = false;
                        setState(() {});
                      }, onCancel: () {
                        _model.charge = false;
                        setState(() {});
                      }, onConfirm: (date) async {
                        print('confirm $date');
                        setState(() {
                          _model.datePicked1 = date;
                        });
                        if (_model.datePicked1 != null) {
                          _model.heureSelect = _model.datePicked1;
                          setState(() {});
                          _model.apiResultf24 = await ApisGoBabiGroup
                              .rechercherReservationCall
                              .call(
                            time: functions.formatTimeString(
                                _model.datePicked1!.toString()),
                            page: '1',
                          );

                          if ((_model.apiResultf24?.succeeded ?? true)) {
                            _model.listeReservations =
                                ApisGoBabiGroup.rechercherReservationCall
                                    .lesReserv(
                                      (_model.apiResultf24?.jsonBody ?? ''),
                                    )!
                                    .toList()
                                    .cast<dynamic>();
                            _model.nbrPage = ApisGoBabiGroup
                                .rechercherReservationCall
                                .nbrPages(
                              (_model.apiResultf24?.jsonBody ?? ''),
                            )!;
                            _model.charge = false;
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erreur lors de la recherche , veuillez réessayer',
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
                        }
                        _model.charge = false;
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.fr);

                      // final _datePicked1Time = await showTimePicker(
                      //   context: context,
                      //   initialTime:
                      //       TimeOfDay.fromDateTime(getCurrentTimestamp),
                      //   builder: (context, child) {
                      //     return wrapInMaterialTimePickerTheme(
                      //       context,
                      //       child!,
                      //       headerBackgroundColor:
                      //           FlutterFlowTheme.of(context).primary,
                      //       headerForegroundColor:
                      //           FlutterFlowTheme.of(context).info,
                      //       headerTextStyle: FlutterFlowTheme.of(context)
                      //           .headlineLarge
                      //           .override(
                      //             fontFamily: 'Outfit',
                      //             fontSize: 32.0,
                      //             letterSpacing: 0.0,
                      //             fontWeight: FontWeight.w600,
                      //           ),
                      //       pickerBackgroundColor: FlutterFlowTheme.of(context)
                      //           .secondaryBackground,
                      //       pickerForegroundColor:
                      //           FlutterFlowTheme.of(context).primaryText,
                      //       selectedDateTimeBackgroundColor:
                      //           FlutterFlowTheme.of(context).primary,
                      //       selectedDateTimeForegroundColor:
                      //           FlutterFlowTheme.of(context).info,
                      //       actionButtonForegroundColor:
                      //           FlutterFlowTheme.of(context).primaryText,
                      //       iconSize: 24.0,
                      //     );
                      //   },
                      // );
                      // if (_datePicked1Time != null) {
                      //   safeSetState(() {
                      //     _model.datePicked1 = DateTime(
                      //       getCurrentTimestamp.year,
                      //       getCurrentTimestamp.month,
                      //       getCurrentTimestamp.day,
                      //       _datePicked1Time.hour,
                      //       _datePicked1Time.minute,
                      //     );
                      //   });
                      // }
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: FlutterFlowTheme.of(context).primary,
                    borderRadius: 20.0,
                    borderWidth: 1.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).primary,
                    icon: Icon(
                      Icons.calendar_month_rounded,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      _model.butRecherche = 'date';
                      setState(() {});
                      final _datePicked2Date = await showDatePicker(
                        locale: Locale('fr', 'FR'),
                        context: context,
                        initialDate: getCurrentTimestamp,
                        firstDate: getCurrentTimestamp,
                        lastDate: DateTime(2050),
                        builder: (context, child) {
                          return wrapInMaterialDatePickerTheme(
                            context,
                            child!,
                            headerBackgroundColor:
                                FlutterFlowTheme.of(context).primary,
                            headerForegroundColor:
                                FlutterFlowTheme.of(context).info,
                            headerTextStyle: FlutterFlowTheme.of(context)
                                .headlineLarge
                                .override(
                                  fontFamily: 'Outfit',
                                  fontSize: 32.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                            pickerBackgroundColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            pickerForegroundColor:
                                FlutterFlowTheme.of(context).primaryText,
                            selectedDateTimeBackgroundColor:
                                FlutterFlowTheme.of(context).primary,
                            selectedDateTimeForegroundColor:
                                FlutterFlowTheme.of(context).info,
                            actionButtonForegroundColor:
                                FlutterFlowTheme.of(context).primaryText,
                            iconSize: 24.0,
                          );
                        },
                      );

                      if (_datePicked2Date != null) {
                        safeSetState(() {
                          _model.datePicked2 = DateTime(
                            _datePicked2Date.year,
                            _datePicked2Date.month,
                            _datePicked2Date.day,
                          );
                        });
                      }
                      if (_model.datePicked2 != null) {
                        _model.dateSelect = _model.datePicked2;
                        _model.charge = true;
                        setState(() {});
                        _model.apiResultf24Copy = await ApisGoBabiGroup
                            .rechercherReservationCall
                            .call(
                          page: '1',
                          date: (String var1) {
                            return var1.split(' ')[0];
                          }(_model.datePicked2!.toString()),
                        );

                        if ((_model.apiResultf24Copy?.succeeded ?? true)) {
                          _model.listeReservations =
                              ApisGoBabiGroup.rechercherReservationCall
                                  .lesReserv(
                                    (_model.apiResultf24Copy?.jsonBody ?? ''),
                                  )!
                                  .toList()
                                  .cast<dynamic>();
                          _model.nbrPage = ApisGoBabiGroup
                              .rechercherReservationCall
                              .nbrPages(
                            (_model.apiResultf24Copy?.jsonBody ?? ''),
                          )!;
                          _model.charge = false;
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Erreur lors de la recherche , veuillez réessayer',
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
                      }
                      _model.charge = false;
                      setState(() {});
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: FlutterFlowTheme.of(context).primary,
                    borderRadius: 20.0,
                    borderWidth: 1.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).primary,
                    icon: Icon(
                      Icons.search_outlined,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      _model.butRecherche = 'startAddress';
                      setState(() {});
                    },
                  ),
                ].divide(SizedBox(width: 5.0)),
              ),
            ],
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Container(
                height: _model.butRecherche == 'startAddress' ? 170.0 : 90.0,
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
                ),
                child: Builder(
                  builder: (context) {
                    if (_model.butRecherche == 'localisation') {
                      return Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Réservations dans votre zone',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                if (_model.apiResult55c != null)
                                  FlutterFlowDropDown<int>(
                                    controller:
                                        _model.locateDropValueController ??=
                                            FormFieldController<int>(
                                      _model.locateDropValue ??= 1,
                                    ),
                                    options: List<int>.from(functions
                                        .generatePageListCopy(_model.nbrPage)),
                                    optionLabels: functions
                                        .generatePageList(_model.nbrPage),
                                    onChanged: (val) async {
                                      setState(
                                          () => _model.locateDropValue = val);
                                      _model.apiResult55cCopy =
                                          await ApisGoBabiGroup
                                              .rechercherReservationCall
                                              .call(
                                        longitude: getJsonField(
                                          FFAppState().userPositionData,
                                          r'''$.longitude''',
                                        ).toString(),
                                        latitude: getJsonField(
                                          FFAppState().userPositionData,
                                          r'''$.latitude''',
                                        ).toString(),
                                        page:
                                            _model.locateDropValue?.toString(),
                                      );

                                      if ((_model.apiResult55cCopy?.succeeded ??
                                          true)) {
                                        _model.listeReservations =
                                            ApisGoBabiGroup
                                                .rechercherReservationCall
                                                .lesReserv(
                                                  (_model.apiResult55cCopy
                                                          ?.jsonBody ??
                                                      ''),
                                                )!
                                                .toList()
                                                .cast<dynamic>();
                                        _model.nbrPage = ApisGoBabiGroup
                                            .rechercherReservationCall
                                            .nbrPages(
                                          (_model.apiResult55cCopy?.jsonBody ??
                                              ''),
                                        )!;
                                        setState(() {});
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Erreur lors de la recherche , veuillez réessayer',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .error,
                                          ),
                                        );
                                      }

                                      setState(() {});
                                    },
                                    width: 100.0,
                                    height: 50.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          letterSpacing: 0.0,
                                        ),
                                    hintText: 'Page',
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    elevation: 2.0,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0.0,
                                    borderRadius: 8.0,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 0.0, 5.0, 0.0),
                                    hidesUnderline: true,
                                    isOverButton: true,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  ),
                              ],
                            ),
                            // Divider(
                            //   thickness: 1.0,
                            //   color: FlutterFlowTheme.of(context).alternate,
                            // ),
                          ],
                        ),
                      );
                    } else if (_model.butRecherche == 'heure') {
                      return Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _model.heureSelect != null
                                      ? 'Réservations à partir de  ${functions.formatTimeString(_model.heureSelect!.toString().split(' ')[1])}'
                                      : 'Réservation à l\'heure',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                if (_model.apiResultf24 != null)
                                  FlutterFlowDropDown<int>(
                                    controller:
                                        _model.heureDropValueController ??=
                                            FormFieldController<int>(
                                      _model.heureDropValue ??= 1,
                                    ),
                                    options: List<int>.from(functions
                                        .generatePageListCopy(_model.nbrPage)),
                                    optionLabels: functions
                                        .generatePageList(_model.nbrPage),
                                    onChanged: (val) async {
                                      setState(
                                          () => _model.heureDropValue = val);
                                      _model.apiResultf24Copy2 =
                                          await ApisGoBabiGroup
                                              .rechercherReservationCall
                                              .call(
                                        time: functions.formatTimeString(
                                            _model.datePicked1!.toString()),
                                        page: _model.heureDropValue?.toString(),
                                      );

                                      if ((_model
                                              .apiResultf24Copy2?.succeeded ??
                                          true)) {
                                        _model.listeReservations =
                                            ApisGoBabiGroup
                                                .rechercherReservationCall
                                                .lesReserv(
                                                  (_model.apiResultf24Copy2
                                                          ?.jsonBody ??
                                                      ''),
                                                )!
                                                .toList()
                                                .cast<dynamic>();
                                        _model.nbrPage = ApisGoBabiGroup
                                            .rechercherReservationCall
                                            .nbrPages(
                                          (_model.apiResultf24Copy2?.jsonBody ??
                                              ''),
                                        )!;
                                        setState(() {});
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Erreur lors de la recherche , veuillez réessayer',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .error,
                                          ),
                                        );
                                      }

                                      setState(() {});
                                    },
                                    width: 100.0,
                                    height: 50.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          letterSpacing: 0.0,
                                        ),
                                    hintText: 'Page',
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    elevation: 2.0,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0.0,
                                    borderRadius: 8.0,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 0.0, 5.0, 0.0),
                                    hidesUnderline: true,
                                    isOverButton: true,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  ),
                              ],
                            ),
                            // Divider(
                            //   thickness: 1.0,
                            //   color: FlutterFlowTheme.of(context).alternate,
                            // ),
                          ],
                        ),
                      );
                    } else if (_model.butRecherche == 'date') {
                      return Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _model.dateSelect != null
                                      ? 'Réservations du : ${functions.formatDateString((String var1) {
                                          return var1.split(' ')[0];
                                        }(_model.dateSelect!.toString()))}'
                                      : 'Réservation par date',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                if (_model.apiResultf24Copy != null)
                                  FlutterFlowDropDown<int>(
                                    controller:
                                        _model.dateDropValueController ??=
                                            FormFieldController<int>(
                                      _model.dateDropValue ??= 1,
                                    ),
                                    options: List<int>.from(functions
                                        .generatePageListCopy(_model.nbrPage)),
                                    optionLabels: functions
                                        .generatePageList(_model.nbrPage),
                                    onChanged: (val) async {
                                      setState(
                                          () => _model.dateDropValue = val);
                                      _model.apiResultf24CopyCopy =
                                          await ApisGoBabiGroup
                                              .rechercherReservationCall
                                              .call(
                                        page: _model.dateDropValue?.toString(),
                                        date: (String var1) {
                                          return var1.split(' ')[0];
                                        }(_model.datePicked2!.toString()),
                                      );

                                      if ((_model.apiResultf24CopyCopy
                                              ?.succeeded ??
                                          true)) {
                                        _model.listeReservations =
                                            ApisGoBabiGroup
                                                .rechercherReservationCall
                                                .lesReserv(
                                                  (_model.apiResultf24CopyCopy
                                                          ?.jsonBody ??
                                                      ''),
                                                )!
                                                .toList()
                                                .cast<dynamic>();
                                        _model.nbrPage = ApisGoBabiGroup
                                            .rechercherReservationCall
                                            .nbrPages(
                                          (_model.apiResultf24CopyCopy
                                                  ?.jsonBody ??
                                              ''),
                                        )!;
                                        setState(() {});
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Erreur lors de la recherche , veuillez réessayer',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .error,
                                          ),
                                        );
                                      }

                                      setState(() {});
                                    },
                                    width: 100.0,
                                    height: 50.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          letterSpacing: 0.0,
                                        ),
                                    hintText: 'Page',
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    elevation: 2.0,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0.0,
                                    borderRadius: 8.0,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 0.0, 5.0, 0.0),
                                    hidesUnderline: true,
                                    isOverButton: true,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  ),
                              ],
                            ),
                            // Divider(
                            //   thickness: 1.0,
                            //   color: FlutterFlowTheme.of(context).alternate,
                            // ),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Réservations à : ${_model.searchAddress}',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                if (_model.apiResult1hb != null)
                                  FlutterFlowDropDown<int>(
                                    controller:
                                        _model.addressDropValueController ??=
                                            FormFieldController<int>(
                                      _model.addressDropValue ??= 1,
                                    ),
                                    options: List<int>.from(functions
                                        .generatePageListCopy(_model.nbrPage)),
                                    optionLabels: functions
                                        .generatePageList(_model.nbrPage),
                                    onChanged: (val) async {
                                      setState(
                                          () => _model.addressDropValue = val);
                                      _model.apiResult1hbCopy =
                                          await ApisGoBabiGroup
                                              .rechercherReservationCall
                                              .call(
                                        startAddress:
                                            _model.textController.text,
                                        page:
                                            _model.addressDropValue?.toString(),
                                      );

                                      if ((_model.apiResult1hbCopy?.succeeded ??
                                          true)) {
                                        _model.listeReservations =
                                            ApisGoBabiGroup
                                                .rechercherReservationCall
                                                .lesReserv(
                                                  (_model.apiResult1hbCopy
                                                          ?.jsonBody ??
                                                      ''),
                                                )!
                                                .toList()
                                                .cast<dynamic>();
                                        _model.nbrPage = ApisGoBabiGroup
                                            .rechercherReservationCall
                                            .nbrPages(
                                          (_model.apiResult1hbCopy?.jsonBody ??
                                              ''),
                                        )!;
                                        setState(() {});
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Erreur lors de la recherche , veuillez réessayer',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .error,
                                          ),
                                        );
                                      }

                                      setState(() {});
                                    },
                                    width: 100.0,
                                    height: 50.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          letterSpacing: 0.0,
                                        ),
                                    hintText: 'Page',
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    elevation: 2.0,
                                    borderColor: Colors.transparent,
                                    borderWidth: 0.0,
                                    borderRadius: 8.0,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 0.0, 5.0, 0.0),
                                    hidesUnderline: true,
                                    isOverButton: true,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  ),
                              ],
                            ),
                            Divider(
                              thickness: 1.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: TextFormField(
                                      controller: _model.textController,
                                      focusNode: _model.textFieldFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.textController',
                                        Duration(milliseconds: 1000),
                                        () async {
                                          _model.searchAddress =
                                              _model.textController.text;
                                          _model.charge = true;
                                          setState(() {});
                                          _model.apiResult1hb =
                                              await ApisGoBabiGroup
                                                  .rechercherReservationCall
                                                  .call(
                                            startAddress:
                                                _model.textController.text,
                                            page: '1',
                                          );

                                          if ((_model.apiResult1hb?.succeeded ??
                                              true)) {
                                            _model.listeReservations =
                                                ApisGoBabiGroup
                                                    .rechercherReservationCall
                                                    .lesReserv(
                                                      (_model.apiResult1hb
                                                              ?.jsonBody ??
                                                          ''),
                                                    )!
                                                    .toList()
                                                    .cast<dynamic>();
                                            _model.nbrPage = ApisGoBabiGroup
                                                .rechercherReservationCall
                                                .nbrPages(
                                              (_model.apiResult1hb?.jsonBody ??
                                                  ''),
                                            )!;
                                            _model.charge = false;
                                            setState(() {});
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Erreur lors de la recherche , veuillez réessayer',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                              ),
                                            );
                                          }
                                          _model.charge = false;
                                          setState(() {});
                                        },
                                      ),
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Recherchez un lieu',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              letterSpacing: 0.0,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            letterSpacing: 0.0,
                                          ),
                                      validator: _model.textControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              // Generated code for this laliste Widget...
              Builder(
                builder: (context) {
                  if (_model.charge == false) {
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20,
                          valueOrDefault<double>(
                            _model.butRecherche == 'startAddress'
                                ? 180.0
                                : 120.0,
                            0.0,
                          ),
                          20,
                          0),
                      child: Builder(
                        builder: (context) {
                          final lesReserv = _model.listeReservations.toList();
                          if (lesReserv.isEmpty) {
                            return Center(
                              child: Image.asset(
                                'assets/images/No_data-pana.png',
                                width: 150,
                                height: 150,
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: lesReserv.length,
                            separatorBuilder: (_, __) => SizedBox(height: 10),
                            itemBuilder: (context, lesReservIndex) {
                              final lesReservItem = lesReserv[lesReservIndex];
                              return InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _model.dejaC =
                                      await queryReservationsRecordOnce(
                                    queryBuilder: (reservationsRecord) =>
                                        reservationsRecord.whereIn('status',
                                            ['arriving', 'in_progress']).where(
                                      'driver_id',
                                      isEqualTo: getJsonField(
                                        FFAppState().userInfo,
                                        r'''$.id''',
                                      ),
                                    ),
                                    singleRecord: true,
                                  ).then((s) => s.firstOrNull);
                                  if (_model.dejaC?.status != null &&
                                      _model.dejaC?.status != '') {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      context: context,
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () =>
                                              FocusScope.of(context).unfocus(),
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: ReservCompWidget(
                                              reservInfo: <String, dynamic>{
                                                'id': getJsonField(
                                                  lesReservItem,
                                                  r'''$.id''',
                                                ),
                                                'status': getJsonField(
                                                  lesReservItem,
                                                  r'''$.status''',
                                                ),
                                              },
                                              status: getJsonField(
                                                lesReservItem,
                                                r'''$.status''',
                                              ).toString(),
                                              dejaEnCourse: true,
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  } else {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      context: context,
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () =>
                                              FocusScope.of(context).unfocus(),
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: ReservCompWidget(
                                              reservInfo: <String, dynamic>{
                                                'id': getJsonField(
                                                  lesReservItem,
                                                  r'''$.id''',
                                                ),
                                                'status': getJsonField(
                                                  lesReservItem,
                                                  r'''$.status''',
                                                ),
                                              },
                                              status: getJsonField(
                                                lesReservItem,
                                                r'''$.status''',
                                              ).toString(),
                                              dejaEnCourse: false,
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x33000000),
                                        offset: Offset(
                                          0,
                                          2,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0x307145D7),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.asset(
                                                          'assets/images/GOBABI_CARS-10.png',
                                                          width: 110,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(0),
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          child: Text(
                                                            '${getJsonField(
                                                              lesReservItem,
                                                              r'''$.montant''',
                                                            ).toString()} FCFA',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .success,
                                                                  fontSize: 10,
                                                                  letterSpacing:
                                                                      0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        child: Text(
                                                          getJsonField(
                                                            lesReservItem,
                                                            r'''$.service_name''',
                                                          ).toString(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                fontSize: 8,
                                                                letterSpacing:
                                                                    0,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ].divide(SizedBox(width: 10)),
                                                ),
                                              ].divide(SizedBox(height: 10)),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          1, -1),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .success,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          child: Text(
                                                            'En attente',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  fontSize: 8,
                                                                  letterSpacing:
                                                                      0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        '#${getJsonField(
                                                          lesReservItem,
                                                          r'''$.id''',
                                                        ).toString()}',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color: Color(
                                                                  0xFF7B7B7B),
                                                              fontSize: 9,
                                                              letterSpacing: 0,
                                                            ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 7)),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                      child: Image.asset(
                                                        'assets/images/bonhomme.png',
                                                        width: 20,
                                                        height: 20,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Text(
                                                      getJsonField(
                                                        lesReservItem,
                                                        r'''$.start_address''',
                                                      )
                                                          .toString()
                                                          .maybeHandleOverflow(
                                                            maxChars: 25,
                                                            replacement: '…',
                                                          ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                fontSize: 10,
                                                                letterSpacing:
                                                                    0,
                                                              ),
                                                    ),
                                                  ].divide(SizedBox(width: 5)),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                      child: Image.asset(
                                                        'assets/images/orange.png',
                                                        width: 20,
                                                        height: 20,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Text(
                                                      getJsonField(
                                                        lesReservItem,
                                                        r'''$.end_address''',
                                                      )
                                                          .toString()
                                                          .maybeHandleOverflow(
                                                            maxChars: 25,
                                                            replacement: '…',
                                                          ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .tertiary,
                                                                fontSize: 10,
                                                                letterSpacing:
                                                                    0,
                                                              ),
                                                    ),
                                                  ].divide(SizedBox(width: 5)),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFEEEEEE),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Icon(
                                                              Icons.access_time,
                                                              color: Color(
                                                                  0xFFAAAAAA),
                                                              size: 12,
                                                            ),
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                functions
                                                                    .formatTimeString(
                                                                        getJsonField(
                                                                  lesReservItem,
                                                                  r'''$.heure''',
                                                                ).toString()),
                                                                '-',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Plus Jakarta Sans',
                                                                    color: Color(
                                                                        0xFF8C8C8C),
                                                                    fontSize:
                                                                        10,
                                                                    letterSpacing:
                                                                        0,
                                                                  ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 4)),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFEEEEEE),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .calendar_today_rounded,
                                                              color: Color(
                                                                  0xFFAAAAAA),
                                                              size: 12,
                                                            ),
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                functions.formatDateString(
                                                                    valueOrDefault<
                                                                        String>(
                                                                  functions
                                                                      .formatDate(
                                                                          getJsonField(
                                                                    lesReservItem,
                                                                    r'''$.date''',
                                                                  ).toString()),
                                                                  '-',
                                                                )),
                                                                '-',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Plus Jakarta Sans',
                                                                    color: Color(
                                                                        0xFF8C8C8C),
                                                                    fontSize:
                                                                        10,
                                                                    letterSpacing:
                                                                        0,
                                                                  ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 4)),
                                                        ),
                                                      ),
                                                    ),
                                                  ].divide(SizedBox(width: 10)),
                                                ),
                                              ].divide(SizedBox(height: 5)),
                                            ),
                                          ].divide(SizedBox(width: 10)),
                                        ),
                                      ),
                                      Container(
                                        width: 7,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(5),
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20,
                          valueOrDefault<double>(
                            _model.butRecherche == 'startAddress'
                                ? 180.0
                                : 120.0,
                            0.0,
                          ),
                          20,
                          0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 100,
                              child: custom_widgets.LeShimmer(
                                width: double.infinity,
                                height: 100,
                                radius: 20.0,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 100,
                              child: custom_widgets.LeShimmer(
                                width: double.infinity,
                                height: 100,
                                radius: 20.0,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 100,
                              child: custom_widgets.LeShimmer(
                                width: double.infinity,
                                height: 100,
                                radius: 20.0,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 100,
                              child: custom_widgets.LeShimmer(
                                width: double.infinity,
                                height: 100,
                                radius: 20.0,
                              ),
                            ),
                          ].divide(SizedBox(height: 10)),
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

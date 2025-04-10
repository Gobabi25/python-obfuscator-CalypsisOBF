import '/backend/api_requests/api_calls.dart';
import '/composants/moyen_paiement/moyen_paiement_widget.dart';
import '/composants/other_rider/other_rider_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'confirm_trajet_copy_model.dart';
export 'confirm_trajet_copy_model.dart';

class ConfirmTrajetCopyWidget extends StatefulWidget {
  const ConfirmTrajetCopyWidget({
    super.key,
    this.depart,
    this.arrivee,
    this.arrets,
    this.trajetInfo,
  });

  final dynamic depart;
  final dynamic arrivee;
  final List<dynamic>? arrets;
  final dynamic trajetInfo;

  @override
  State<ConfirmTrajetCopyWidget> createState() =>
      _ConfirmTrajetCopyWidgetState();
}

class _ConfirmTrajetCopyWidgetState extends State<ConfirmTrajetCopyWidget> {
  late ConfirmTrajetCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConfirmTrajetCopyModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.arrets != null && (widget.arrets)!.isNotEmpty) {
        _model.tabTrajet = widget.arrets!.toList().cast<dynamic>();
        _model.arreTs = widget.arrets!.toList().cast<dynamic>();
        setState(() {});
        _model.insertAtIndexInTabTrajet(0, widget.depart!);
        setState(() {});
        _model.addToTabTrajet(widget.arrivee!);
        setState(() {});
      } else {
        await actions.printer();
        _model.addToTabTrajet(widget.depart!);
        setState(() {});
        _model.addToTabTrajet(widget.arrivee!);
        setState(() {});
      }

      _model.resCalT = await actions.sendGetRequestWithParams(
        '${getJsonField(
          widget.depart,
          r'''$.latitude''',
        ).toString().toString()},${getJsonField(
          widget.depart,
          r'''$.longitude''',
        ).toString().toString()}',
        '${getJsonField(
          widget.arrivee,
          r'''$.latitude''',
        ).toString().toString()},${getJsonField(
          widget.arrivee,
          r'''$.longitude''',
        ).toString().toString()}',
        functions.formattedCord(widget.arrets?.toList()).toList(),
        FFAppConstants.hereMapApiKey,
        'summary',
      );
      _model.apiRes3 = await ApisGoBabiGroup.estimatePriceWithDistanceCall.call(
        distance: functions
            .distanceAndDuration(_model.resCalT!.toList())
            .first
            .toString(),
      );

      if ((_model.apiRes3?.succeeded ?? true)) {
        _model.laRep = (_model.apiRes3?.jsonBody ?? '');
        _model.laRepPrem =
            ApisGoBabiGroup.estimatePriceWithDistanceCall.premierService(
          (_model.apiRes3?.jsonBody ?? ''),
        );
        _model.laRepDeux =
            ApisGoBabiGroup.estimatePriceWithDistanceCall.deuxiemeService(
          (_model.apiRes3?.jsonBody ?? ''),
        );
        setState(() {});
        _model.charge = false;
        _model.services = _model.laRep!.toList().cast<dynamic>();
        setState(() {});
        _model.choixService = _model.laRepPrem;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Une erreur est survenue , veuillez réessayer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    });
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
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: true,
          title: Text(
            'Confirmation du trajet',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 80.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 250.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.asset(
                                      'assets/images/Capture_decran_2024-06-05_a_15.49.36.png',
                                    ).image,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                              ),
                              if (_model.charge == false)
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            _model.choixService = ApisGoBabiGroup
                                                .estimatePriceWithDistanceCall
                                                .premierService(
                                              (_model.apiRes3?.jsonBody ?? ''),
                                            );
                                            setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: getJsonField(
                                                        _model.choixService,
                                                        r'''$.name''',
                                                      ) ==
                                                      getJsonField(
                                                        _model.laRepPrem,
                                                        r'''$.name''',
                                                      )
                                                  ? Color(0xFF754CE3)
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/2237829n.png',
                                                          width: 120.0,
                                                          height: 80.0,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/GOBABI_CARS-09.png',
                                                          width: 140.0,
                                                          height: 80.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    getJsonField(
                                                      _model.services.first,
                                                      r'''$.name''',
                                                    ).toString().toUpperCase(),
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color:
                                                                  getJsonField(
                                                                            _model.choixService,
                                                                            r'''$.name''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            _model.laRepPrem,
                                                                            r'''$.name''',
                                                                          )
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                              fontSize: 11.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                  ),
                                                  Text(
                                                    '${getJsonField(
                                                      _model.services.first,
                                                      r'''$.result''',
                                                    ).toString()} FCFA',
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color:
                                                                  getJsonField(
                                                                            _model.choixService,
                                                                            r'''$.name''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            _model.laRepPrem,
                                                                            r'''$.name''',
                                                                          )
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .tertiary,
                                                              fontSize: 15.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                  ),
                                                ].divide(SizedBox(height: 5.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            _model.choixService = ApisGoBabiGroup
                                                .estimatePriceWithDistanceCall
                                                .deuxiemeService(
                                              (_model.apiRes3?.jsonBody ?? ''),
                                            );
                                            setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: getJsonField(
                                                        _model.choixService,
                                                        r'''$.name''',
                                                      ) ==
                                                      getJsonField(
                                                        _model.laRepDeux,
                                                        r'''$.name''',
                                                      )
                                                  ? Color(0xFF754CE3)
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/2237829n.png',
                                                          width: 140.0,
                                                          height: 80.0,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/GOBABI_CARS-10.png',
                                                          width: 140.0,
                                                          height: 80.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    getJsonField(
                                                      _model.services.last,
                                                      r'''$.name''',
                                                    ).toString().toUpperCase(),
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color:
                                                                  getJsonField(
                                                                            _model.choixService,
                                                                            r'''$.name''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            _model.laRepDeux,
                                                                            r'''$.name''',
                                                                          )
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                              fontSize: 11.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                  ),
                                                  Text(
                                                    '${getJsonField(
                                                      _model.services.last,
                                                      r'''$.result''',
                                                    ).toString()} FCFA',
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color:
                                                                  getJsonField(
                                                                            _model.choixService,
                                                                            r'''$.name''',
                                                                          ) ==
                                                                          getJsonField(
                                                                            _model.laRepDeux,
                                                                            r'''$.name''',
                                                                          )
                                                                      ? FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground
                                                                      : Color(
                                                                          0xFF754CE3),
                                                              fontSize: 15.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                  ),
                                                ].divide(SizedBox(height: 5.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (_model.charge == true)
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: 120.0,
                                          child: custom_widgets.LeShimmer(
                                            width: 100.0,
                                            height: 120.0,
                                            radius: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          height: 120.0,
                                          child: custom_widgets.LeShimmer(
                                            width: 100.0,
                                            height: 120.0,
                                            radius: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 20.0)),
                                ),
                              Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
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
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                              'creationTrajet',
                                              queryParameters: {
                                                'depart': serializeParam(
                                                  widget.depart,
                                                  ParamType.JSON,
                                                ),
                                                'arrivee': serializeParam(
                                                  widget.arrivee,
                                                  ParamType.JSON,
                                                ),
                                                'arrets': serializeParam(
                                                  _model.arreTs,
                                                  ParamType.JSON,
                                                  isList: true,
                                                ),
                                                'prevInterface': serializeParam(
                                                  'confirmTrajet',
                                                  ParamType.String,
                                                ),
                                                'focus': serializeParam(
                                                  'depart',
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                              extra: <String, dynamic>{
                                                kTransitionInfoKey:
                                                    TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType
                                                          .leftToRight,
                                                ),
                                              },
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                10.0, 0.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 4.0,
                                                            color: Color(
                                                                0x33000000),
                                                            offset: Offset(
                                                              0.0,
                                                              2.0,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/bonhomme.png',
                                                          width: 30.0,
                                                          height: 30.0,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    getJsonField(
                                                      widget.depart,
                                                      r'''$.display_name''',
                                                    )
                                                        .toString()
                                                        .maybeHandleOverflow(
                                                          maxChars: 24,
                                                          replacement: '…',
                                                        ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          color:
                                                              Color(0xFF7145D7),
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 10.0)),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1.0,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Builder(
                                              builder: (context) {
                                                final lesArrets =
                                                    _model.arreTs.toList();
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: List.generate(
                                                      lesArrets.length,
                                                      (lesArretsIndex) {
                                                    final lesArretsItem =
                                                        lesArrets[
                                                            lesArretsIndex];
                                                    return Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () async {
                                                              context.pushNamed(
                                                                'creationArretTrajet',
                                                                queryParameters:
                                                                    {
                                                                  'depart':
                                                                      serializeParam(
                                                                    widget
                                                                        .depart,
                                                                    ParamType
                                                                        .JSON,
                                                                  ),
                                                                  'arrivee':
                                                                      serializeParam(
                                                                    widget
                                                                        .arrivee,
                                                                    ParamType
                                                                        .JSON,
                                                                  ),
                                                                  'arrets':
                                                                      serializeParam(
                                                                    _model
                                                                        .arreTs,
                                                                    ParamType
                                                                        .JSON,
                                                                    isList:
                                                                        true,
                                                                  ),
                                                                  'prevInterface':
                                                                      serializeParam(
                                                                    'confirmTrajet',
                                                                    ParamType
                                                                        .String,
                                                                  ),
                                                                }.withoutNulls,
                                                                extra: <String,
                                                                    dynamic>{
                                                                  kTransitionInfoKey:
                                                                      TransitionInfo(
                                                                    hasTransition:
                                                                        true,
                                                                    transitionType:
                                                                        PageTransitionType
                                                                            .leftToRight,
                                                                  ),
                                                                },
                                                              );
                                                            },
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                          10.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            10.0,
                                                                            0.0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .drag_indicator_rounded,
                                                                          color:
                                                                              Color(0xFFB8BBBE),
                                                                          size:
                                                                              18.0,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${lesArretsIndex.toString()} - ${getJsonField(
                                                                          lesArretsItem,
                                                                          r'''$.display_name''',
                                                                        ).toString()}'
                                                                            .maybeHandleOverflow(
                                                                          maxChars:
                                                                              20,
                                                                          replacement:
                                                                              '…',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Plus Jakarta Sans',
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        FlutterFlowIconButton(
                                                          borderColor: Colors
                                                              .transparent,
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 40.0,
                                                          icon: Icon(
                                                            Icons
                                                                .remove_circle_outlined,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            size: 24.0,
                                                          ),
                                                          showLoadingIndicator:
                                                              true,
                                                          onPressed: () async {
                                                            _model
                                                                .removeAtIndexFromArreTs(
                                                                    getJsonField(
                                                              lesArretsItem,
                                                              r'''$.id''',
                                                            ));
                                                            setState(() {});
                                                            _model.resCalT2 =
                                                                await actions
                                                                    .sendGetRequestWithParams(
                                                              '${getJsonField(
                                                                widget.depart,
                                                                r'''$.latitude''',
                                                              ).toString()},${getJsonField(
                                                                widget.depart,
                                                                r'''$.longitude''',
                                                              ).toString()}',
                                                              '${getJsonField(
                                                                widget.arrivee,
                                                                r'''$.latitude''',
                                                              ).toString()},${getJsonField(
                                                                widget.arrivee,
                                                                r'''$.longitude''',
                                                              ).toString()}',
                                                              functions
                                                                  .formattedCord(
                                                                      widget
                                                                          .arrets
                                                                          ?.toList())
                                                                  .toList(),
                                                              FFAppConstants
                                                                  .hereMapApiKey,
                                                              'summary',
                                                            );
                                                            _model.resCalQ = _model
                                                                .resCalT2!
                                                                .toList()
                                                                .cast<
                                                                    dynamic>();
                                                            setState(() {});
                                                            _model.apiRes32 =
                                                                await ApisGoBabiGroup
                                                                    .estimatePriceWithDistanceCall
                                                                    .call(
                                                              distance: _model
                                                                  .resCalT2
                                                                  ?.first
                                                                  ?.toString(),
                                                            );

                                                            if ((_model.apiRes32
                                                                    ?.succeeded ??
                                                                true)) {
                                                              _model
                                                                  .laRep = (_model
                                                                      .apiRes32
                                                                      ?.jsonBody ??
                                                                  '');
                                                              _model.laRepPrem =
                                                                  ApisGoBabiGroup
                                                                      .estimatePriceWithDistanceCall
                                                                      .premierService(
                                                                (_model.apiRes32
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              );
                                                              _model.laRepDeux =
                                                                  ApisGoBabiGroup
                                                                      .estimatePriceWithDistanceCall
                                                                      .deuxiemeService(
                                                                (_model.apiRes32
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              );
                                                              setState(() {});
                                                              _model.charge =
                                                                  false;
                                                              _model.services =
                                                                  _model.laRep!
                                                                      .toList()
                                                                      .cast<
                                                                          dynamic>();
                                                              setState(() {});
                                                              _model.choixService =
                                                                  _model
                                                                      .laRepPrem;
                                                              setState(() {});
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    'Une erreur est survenue , veuillez réessayer',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          15.0,
                                                                    ),
                                                                  ),
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          4000),
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                ),
                                                              );
                                                            }

                                                            setState(() {});
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  'creationArretTrajet',
                                                  queryParameters: {
                                                    'depart': serializeParam(
                                                      widget.depart,
                                                      ParamType.JSON,
                                                    ),
                                                    'arrivee': serializeParam(
                                                      widget.arrivee,
                                                      ParamType.JSON,
                                                    ),
                                                    'arrets': serializeParam(
                                                      _model.arreTs,
                                                      ParamType.JSON,
                                                      isList: true,
                                                    ),
                                                    'prevInterface':
                                                        serializeParam(
                                                      'confirmTrajet',
                                                      ParamType.String,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey:
                                                        TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType:
                                                          PageTransitionType
                                                              .leftToRight,
                                                    ),
                                                  },
                                                );
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 10.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Icon(
                                                            Icons.add_sharp,
                                                            color: Color(
                                                                0xFFB8BBBE),
                                                            size: 18.0,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Ajouter un arret',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                              'creationTrajet',
                                              queryParameters: {
                                                'depart': serializeParam(
                                                  widget.depart,
                                                  ParamType.JSON,
                                                ),
                                                'arrivee': serializeParam(
                                                  widget.arrivee,
                                                  ParamType.JSON,
                                                ),
                                                'arrets': serializeParam(
                                                  _model.arreTs,
                                                  ParamType.JSON,
                                                  isList: true,
                                                ),
                                                'prevInterface': serializeParam(
                                                  'confirmTrajet',
                                                  ParamType.String,
                                                ),
                                                'focus': serializeParam(
                                                  'arrivee',
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                              extra: <String, dynamic>{
                                                kTransitionInfoKey:
                                                    TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType
                                                          .leftToRight,
                                                ),
                                              },
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                10.0, 0.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 4.0,
                                                            color: Color(
                                                                0x33000000),
                                                            offset: Offset(
                                                              0.0,
                                                              2.0,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/orange.png',
                                                          width: 30.0,
                                                          height: 30.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        getJsonField(
                                                          widget.arrivee,
                                                          r'''$.display_name''',
                                                        )
                                                            .toString()
                                                            .maybeHandleOverflow(
                                                              maxChars: 20,
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
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                      Text(
                                                        'Distance totale : ${functions.distanceAndDuration(_model.resCalT!.toList()).first.toString()} Km',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color: Color(
                                                                  0xFF9B9B9B),
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 3.0)),
                                                  ),
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 10.0)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Moyen de paiement',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  color: Color(0xFF8E9296),
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                enableDrag: false,
                                                context: context,
                                                builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () => _model
                                                            .unfocusNode
                                                            .canRequestFocus
                                                        ? FocusScope.of(context)
                                                            .requestFocus(_model
                                                                .unfocusNode)
                                                        : FocusScope.of(context)
                                                            .unfocus(),
                                                    child: Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child:
                                                          MoyenPaiementWidget(),
                                                    ),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFF754CE3),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    if (valueOrDefault<bool>(
                                                      FFAppState()
                                                              .moyenPaiement ==
                                                          'Cash',
                                                      true,
                                                    ))
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/Coins-amico.png',
                                                          width: 30.0,
                                                          height: 30.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    if (FFAppState()
                                                            .moyenPaiement ==
                                                        'Wave')
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.asset(
                                                          'assets/images/wave.png',
                                                          width: 30.0,
                                                          height: 30.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    Text(
                                                      FFAppState()
                                                          .moyenPaiement,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            color: Colors.white,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(width: 5.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 20.0)),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 10.0)),
                                ),
                              ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Container(
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Divider(
                              thickness: 1.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        enableDrag: false,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () => _model
                                                    .unfocusNode.canRequestFocus
                                                ? FocusScope.of(context)
                                                    .requestFocus(
                                                        _model.unfocusNode)
                                                : FocusScope.of(context)
                                                    .unfocus(),
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: OtherRiderWidget(
                                                infosCourse: <String, dynamic>{
                                                  'service_id': getJsonField(
                                                    _model.choixService,
                                                    r'''$.id''',
                                                  ),
                                                  'datetime':
                                                      getCurrentTimestamp,
                                                  'start_latitude':
                                                      getJsonField(
                                                    widget.depart,
                                                    r'''$.latitude''',
                                                  ),
                                                  'start_longitude':
                                                      getJsonField(
                                                    widget.depart,
                                                    r'''$.longitude''',
                                                  ),
                                                  'start_address': getJsonField(
                                                    widget.depart,
                                                    r'''$.display_name''',
                                                  ),
                                                  'end_latitude': getJsonField(
                                                    widget.arrivee,
                                                    r'''$.latitude''',
                                                  ),
                                                  'end_longitude': getJsonField(
                                                    widget.arrivee,
                                                    r'''$.longitude''',
                                                  ),
                                                  'end_address': getJsonField(
                                                    widget.arrivee,
                                                    r'''$.display_name''',
                                                  ),
                                                  'montant': getJsonField(
                                                    _model.choixService,
                                                    r'''$.result''',
                                                  ),
                                                  'status':
                                                      FFAppState().leStatus[3],
                                                  'is_ride_for_other':
                                                      FFAppState()
                                                          .otherDriverBol
                                                          .last,
                                                  'distance': _model.resCalT2 !=
                                                              null &&
                                                          (_model.resCalT2)!
                                                              .isNotEmpty
                                                      ? functions
                                                          .distanceAndDuration(
                                                              _model.resCalT2!
                                                                  .toList())
                                                          .first
                                                      : functions
                                                          .distanceAndDuration(
                                                              _model.resCalT!
                                                                  .toList())
                                                          .first,
                                                  'duration': _model.resCalT2 !=
                                                              null &&
                                                          (_model.resCalT2)!
                                                              .isNotEmpty
                                                      ? functions
                                                          .distanceAndDuration(
                                                              _model.resCalT2!
                                                                  .toList())
                                                          .last
                                                      : functions
                                                          .distanceAndDuration(
                                                              _model.resCalT!
                                                                  .toList())
                                                          .last,
                                                  'arret_coordonnee': functions
                                                      .transformJsonListToString(
                                                          widget.arrets
                                                              ?.toList()),
                                                  'token': FFAppState().token,
                                                  'driver_id': getJsonField(
                                                    FFAppState().userInfo,
                                                    r'''$.id''',
                                                  ),
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    text: 'Continuer',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 50.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: Color(0xFF7145D7),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                      elevation: 0.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 10.0)),
                            ),
                          ].divide(SizedBox(height: 10.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

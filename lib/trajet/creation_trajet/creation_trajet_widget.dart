import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'creation_trajet_model.dart';
export 'creation_trajet_model.dart';

class CreationTrajetWidget extends StatefulWidget {
  const CreationTrajetWidget({
    super.key,
    this.depart,
    this.arrivee,
    this.arrets,
    bool? change,
    this.prevInterface,
    this.focus,
  }) : this.change = change ?? false;

  final dynamic depart;
  final dynamic arrivee;
  final List<dynamic>? arrets;
  final bool change;
  final String? prevInterface;
  final String? focus;

  @override
  State<CreationTrajetWidget> createState() => _CreationTrajetWidgetState();
}

class _CreationTrajetWidgetState extends State<CreationTrajetWidget> {
  late CreationTrajetModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // late OfflineSearchEngine _offlineSearchEngine;
  bool useOnlineSearchEngine = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreationTrajetModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          if (widget.depart != null) {
            _model.departChoix = widget.depart;
            setState(() {});
            setState(() {
              _model.departTextController?.text = getJsonField(
                widget.depart,
                r'''$.display_name''',
              ).toString().toString();
              _model.departTextController?.selection = TextSelection.collapsed(
                  offset: _model.departTextController!.text.length);
            });
          }
        }),
        Future(() async {
          if (widget.arrivee != null) {
            _model.arriveeChoix = widget.arrivee;
            setState(() {});
            setState(() {
              _model.arriveeTextController?.text = getJsonField(
                widget.arrivee,
                r'''$.display_name''',
              ).toString().toString();
              _model.arriveeTextController?.selection = TextSelection.collapsed(
                  offset: _model.arriveeTextController!.text.length);
            });
          }
        }),
        Future(() async {
          if (widget.arrets != null && (widget.arrets)!.isNotEmpty) {
            _model.arretChoix = widget.arrets!.toList().cast<dynamic>();
            setState(() {});
          }
        }),
      ]);
    });

    _model.departTextController ??= TextEditingController(
        text: widget.depart != null
            ? getJsonField(
                widget.depart,
                r'''$.display_name''',
              ).toString().toString()
            : '');
    _model.departFocusNode ??= FocusNode();

    _model.arriveeTextController ??= TextEditingController(
        text: widget.arrivee != null
            ? getJsonField(
                widget.arrivee,
                r'''$.display_name''',
              ).toString().toString()
            : '');
    _model.arriveeFocusNode ??= FocusNode();
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: true,
          title: Text(
            'Configurez votre trajet',
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
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              height: double.infinity,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 155.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.0,
                          color: Color(0x1E000000),
                          offset: Offset(
                            0.0,
                            2.0,
                          ),
                          spreadRadius: 4.0,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
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
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/bonhomme.png',
                                        width: 30.0,
                                        height: 30.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _model.departTextController,
                                      focusNode: _model.departFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.departTextController',
                                        Duration(milliseconds: 200),
                                        () async {
                                          _model.arrivee = false;
                                          _model.arret = false;
                                          _model.depart = true;
                                          _model.departList = functions
                                              .listeVide()
                                              .toList()
                                              .cast<dynamic>();
                                          setState(() {});
                                          await Future.wait([
                                            Future(() async {
                                              _model.apiResultagb =
                                                  await GeoApiFyCall.call(
                                                q: _model
                                                    .departTextController.text,
                                              );
                                            }),
                                            Future(() async {
                                              _model.apiResult9yr =
                                                  await ApisGoBabiGroup
                                                      .getAddressesEnregistreesCall
                                                      .call(
                                                address: _model
                                                    .departTextController.text,
                                              );
                                            })
                                          ]);

                                          if ((_model.apiResultagb?.succeeded ??
                                                  true) &&
                                              (_model.apiResult9yr?.succeeded ??
                                                  true)) {
                                            _model.departList = functions
                                                .combinedList(
                                                    getJsonField(
                                                      (_model.apiResultagb
                                                              ?.jsonBody ??
                                                          ''),
                                                      r'''$.results''',
                                                      true,
                                                    )!,
                                                    getJsonField(
                                                      (_model.apiResult9yr
                                                              ?.jsonBody ??
                                                          ''),
                                                      r'''$.results''',
                                                      true,
                                                    )!)
                                                .toList()
                                                .cast<dynamic>();
                                            setState(() {});
                                          }

                                          setState(() {});
                                        },
                                      ),
                                      autofocus: widget.focus == 'depart'
                                          ? true
                                          : false,
                                      readOnly: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Départ',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              color: Color(0xFF7145D7),
                                              letterSpacing: 0.0,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        // suffixIcon: _model.departTextController!
                                        //         .text.isNotEmpty
                                        //     ? InkWell(
                                        //         onTap: () async {
                                        //           _model.departTextController
                                        //               ?.clear();
                                        //           _model.depart = true;
                                        //           _model.arrivee = false;
                                        //           _model.arret = false;
                                        //           setState(() {});
                                        //           _model.apiResultagb =
                                        //               await HeregobabiCall.call(
                                        //             q: _model
                                        //                 .departTextController
                                        //                 .text,
                                        //             apiKey: FFAppConstants
                                        //                 .hereMapApiKey,
                                        //           );

                                        //           if ((_model.apiResultagb
                                        //                   ?.succeeded ??
                                        //               true)) {
                                        //             _model.departList =
                                        //                 getJsonField(
                                        //               (_model.apiResultagb
                                        //                       ?.jsonBody ??
                                        //                   ''),
                                        //               r'''$.items''',
                                        //               true,
                                        //             )!
                                        //                     .toList()
                                        //                     .cast<dynamic>();
                                        //             setState(() {});
                                        //           }

                                        //           setState(() {});
                                        //           setState(() {});
                                        //         },
                                        //         child: Icon(
                                        //           Icons.clear,
                                        //           color: FlutterFlowTheme.of(
                                        //                   context)
                                        //               .secondaryText,
                                        //           size: 22,
                                        //         ),
                                        //       )
                                        //     : null,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            letterSpacing: 0.0,
                                          ),
                                      validator: _model
                                          .departTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  // InkWell(
                                  //   splashColor: Colors.transparent,
                                  //   focusColor: Colors.transparent,
                                  //   hoverColor: Colors.transparent,
                                  //   highlightColor: Colors.transparent,
                                  //   onTap: () async {
                                  //     context.pushNamed(
                                  //       'placementCarte',
                                  //       queryParameters: {
                                  //         'depart': serializeParam(
                                  //           _model.departChoix,
                                  //           ParamType.JSON,
                                  //         ),
                                  //         'arrets': serializeParam(
                                  //           _model.arretChoix,
                                  //           ParamType.JSON,
                                  //           isList: true,
                                  //         ),
                                  //         'arrivee': serializeParam(
                                  //           _model.arriveeChoix,
                                  //           ParamType.JSON,
                                  //         ),
                                  //         'index': serializeParam(
                                  //           0,
                                  //           ParamType.int,
                                  //         ),
                                  //       }.withoutNulls,
                                  //     );
                                  //   },
                                  //   child: Icon(
                                  //     Icons.my_location,
                                  //     color: Color(0xFF868E96),
                                  //     size: 24.0,
                                  //   ),
                                  // ),
                                ].divide(SizedBox(width: 10.0)),
                              ),
                              Divider(
                                thickness: 1.0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
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
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/orange.png',
                                        width: 30.0,
                                        height: 30.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _model.arriveeTextController,
                                      focusNode: _model.arriveeFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.arriveeTextController',
                                        Duration(milliseconds: 200),
                                        () async {
                                          _model.arrivee = true;
                                          _model.arret = false;
                                          _model.depart = false;
                                          _model.departList = functions
                                              .listeVide()
                                              .toList()
                                              .cast<dynamic>();
                                          setState(() {});
                                          await Future.wait([
                                            Future(() async {
                                              _model.apiResultagbCopy =
                                                  await GeoApiFyCall.call(
                                                q: _model
                                                    .arriveeTextController.text,
                                              );
                                            }),
                                            Future(() async {
                                              _model.apiResult9yr =
                                                  await ApisGoBabiGroup
                                                      .getAddressesEnregistreesCall
                                                      .call(
                                                address: _model
                                                    .arriveeTextController.text,
                                              );
                                            })
                                          ]);

                                          if ((_model.apiResultagbCopy
                                                      ?.succeeded ??
                                                  true) &&
                                              (_model.apiResult9yr?.succeeded ??
                                                  true)) {
                                            _model.departList = functions
                                                .combinedList(
                                                    getJsonField(
                                                      (_model.apiResultagbCopy
                                                              ?.jsonBody ??
                                                          ''),
                                                      r'''$.results''',
                                                      true,
                                                    )!,
                                                    getJsonField(
                                                      (_model.apiResult9yr
                                                              ?.jsonBody ??
                                                          ''),
                                                      r'''$.results''',
                                                      true,
                                                    )!)
                                                .toList()
                                                .cast<dynamic>();
                                            setState(() {});
                                          }

                                          setState(() {});
                                        },
                                      ),
                                      autofocus: widget.focus == 'arrivee'
                                          ? true
                                          : false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Arrivée',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .tertiary,
                                              letterSpacing: 0.0,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        suffixIcon: _model
                                                .arriveeTextController!
                                                .text
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () async {
                                                  _model.arriveeTextController
                                                      ?.clear();
                                                  _model.depart = false;
                                                  _model.arret = false;
                                                  _model.arrivee = true;
                                                  setState(() {});
                                                  _model.apiResultagbCopy =
                                                      await GeoApiFyCall.call(
                                                    q: _model
                                                        .arriveeTextController
                                                        .text,
                                                  );

                                                  if ((_model.apiResultagbCopy
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.departList =
                                                        getJsonField(
                                                      (_model.apiResultagbCopy
                                                              ?.jsonBody ??
                                                          ''),
                                                      r'''$.results''',
                                                      true,
                                                    )!
                                                            .toList()
                                                            .cast<dynamic>();
                                                    setState(() {});
                                                  }

                                                  setState(() {});
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.clear,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 22,
                                                ),
                                              )
                                            : null,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            letterSpacing: 0.0,
                                          ),
                                      validator: _model
                                          .arriveeTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  // InkWell(
                                  //   splashColor: Colors.transparent,
                                  //   focusColor: Colors.transparent,
                                  //   hoverColor: Colors.transparent,
                                  //   highlightColor: Colors.transparent,
                                  //   onTap: () async {
                                  //     context.pushNamed(
                                  //       'placementCarte',
                                  //       queryParameters: {
                                  //         'index': serializeParam(
                                  //           -1,
                                  //           ParamType.int,
                                  //         ),
                                  //         'depart': serializeParam(
                                  //           _model.departChoix,
                                  //           ParamType.JSON,
                                  //         ),
                                  //         'arrets': serializeParam(
                                  //           _model.arretChoix,
                                  //           ParamType.JSON,
                                  //           isList: true,
                                  //         ),
                                  //         'arrivee': serializeParam(
                                  //           _model.arriveeChoix,
                                  //           ParamType.JSON,
                                  //         ),
                                  //       }.withoutNulls,
                                  //     );
                                  //   },
                                  //   child: Icon(
                                  //     Icons.my_location,
                                  //     color: Color(0xFF868E96),
                                  //     size: 24.0,
                                  //   ),
                                  // ),
                                ].divide(SizedBox(width: 10.0)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 160.0, 0.0, 0.0),
                    child: Container(
                      height: double.infinity,
                      child: Stack(
                        children: [
                          if (_model.arrivee)
                            Builder(
                              builder: (context) {
                                final arriveeList = _model.departList.toList();
                                if (arriveeList.isEmpty) {
                                  return Center(
                                    child: Image.asset(
                                      'assets/images/Order_ride-amico.png',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: arriveeList.length,
                                  itemBuilder: (context, arriveeListIndex) {
                                    final arriveeListItem =
                                        arriveeList[arriveeListIndex];
                                    return Visibility(
                                      visible: functions
                                          .doesNotContainRussianCharacters(
                                              getJsonField(
                                        arriveeListItem,
                                        r'''$.text''',
                                      ).toString()),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          setState(() {
                                            _model.arriveeTextController?.text =
                                                //     functions.reconv(getJsonField(
                                                //   arriveeListItem,
                                                //   r'''$.title''',
                                                // ).toString())
                                                getJsonField(
                                              arriveeListItem,
                                              r'''$.text''',
                                            ).toString();
                                            _model.arriveeTextController
                                                    ?.selection =
                                                TextSelection.collapsed(
                                                    offset: _model
                                                        .arriveeTextController!
                                                        .text
                                                        .length);
                                          });
                                          _model.arriveeChoix =
                                              <String, dynamic>{
                                            'display_name':
                                                //     functions.reconv(getJsonField(
                                                //   arriveeListItem,
                                                //   r'''$.title''',
                                                // ).toString())
                                                getJsonField(
                                              arriveeListItem,
                                              r'''$.text''',
                                            ).toString(),
                                            'latitude': getJsonField(
                                              arriveeListItem,
                                              r'''$.position[1]''',
                                            ),
                                            'longitude': getJsonField(
                                              arriveeListItem,
                                              r'''$.position[0]''',
                                            ),
                                          };
                                          setState(() {});
                                          if (_model.departChoix != null) {
                                            if ((widget.prevInterface ==
                                                    'confirmTrajet') ||
                                                (widget.prevInterface ==
                                                    'pageAccueil')) {
                                              context.pushNamed(
                                                'confirmTrajet',
                                                queryParameters: {
                                                  'depart': serializeParam(
                                                    _model.departChoix,
                                                    ParamType.JSON,
                                                  ),
                                                  'arrivee': serializeParam(
                                                    _model.arriveeChoix,
                                                    ParamType.JSON,
                                                  ),
                                                  'arrets': serializeParam(
                                                    _model.arretChoix,
                                                    ParamType.JSON,
                                                    isList: true,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            } else {
                                              context.pushNamed('infosTrajet');
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 5.0, 10.0),
                                                  child: Icon(
                                                    Icons.add_location_sharp,
                                                    color: Color(0xFFC2C4C8),
                                                    size: 24.0,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        // functions
                                                        //     .reconv(getJsonField(
                                                        //   arriveeListItem,
                                                        //   r'''$.title''',
                                                        // ).toString())
                                                        getJsonField(
                                                          arriveeListItem,
                                                          r'''$.text''',
                                                        ).toString(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                      Text(
                                                        // functions
                                                        //     .reconv(getJsonField(
                                                        //   arriveeListItem,
                                                        //   r'''$.title''',
                                                        // ).toString())
                                                        functions
                                                            .removeRussianCharacters(
                                                                getJsonField(
                                                          arriveeListItem,
                                                          r'''$.subtitle.text''',
                                                        ).toString()),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color: Color(
                                                                  0xFF959595),
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      Divider(
                                                        thickness: 1.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          if (_model.depart)
                            Builder(
                              builder: (context) {
                                final lesDeparts = _model.departList.toList();
                                if (lesDeparts.isEmpty) {
                                  return Center(
                                    child: Image.asset(
                                      'assets/images/Order_ride-amico.png',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: lesDeparts.length,
                                  itemBuilder: (context, lesDepartsIndex) {
                                    final lesDepartsItem =
                                        lesDeparts[lesDepartsIndex];
                                    return Visibility(
                                      visible: functions
                                          .doesNotContainRussianCharacters(
                                              getJsonField(
                                        lesDepartsItem,
                                        r'''$.text''',
                                      ).toString()),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          setState(() {
                                            _model.departTextController?.text =
                                                //     functions.reconv(getJsonField(
                                                //   lesDepartsItem,
                                                //   r'''$.title''',
                                                // ).toString())
                                                getJsonField(
                                              lesDepartsItem,
                                              r'''$.text''',
                                            ).toString();
                                            _model.departTextController
                                                    ?.selection =
                                                TextSelection.collapsed(
                                                    offset: _model
                                                        .departTextController!
                                                        .text
                                                        .length);
                                          });
                                          _model.departChoix =
                                              <String, dynamic>{
                                            'display_name':
                                                //     functions.reconv(getJsonField(
                                                //   lesDepartsItem,
                                                //   r'''$.title''',
                                                // ).toString())
                                                getJsonField(
                                              lesDepartsItem,
                                              r'''$.text''',
                                            ).toString(),
                                            'latitude': getJsonField(
                                              lesDepartsItem,
                                              r'''$.position[1]''',
                                            ),
                                            'longitude': getJsonField(
                                              lesDepartsItem,
                                              r'''$.position[0]''',
                                            ),
                                          };
                                          setState(() {});
                                          if (_model.arriveeChoix != null) {
                                            if ((widget.prevInterface ==
                                                    'confirmTrajet') ||
                                                (widget.prevInterface ==
                                                    'pageAccueil')) {
                                              context.pushNamed(
                                                'confirmTrajet',
                                                queryParameters: {
                                                  'depart': serializeParam(
                                                    _model.departChoix,
                                                    ParamType.JSON,
                                                  ),
                                                  'arrivee': serializeParam(
                                                    _model.arriveeChoix,
                                                    ParamType.JSON,
                                                  ),
                                                  'arrets': serializeParam(
                                                    _model.arretChoix,
                                                    ParamType.JSON,
                                                    isList: true,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            } else {
                                              context.pushNamed('infosTrajet');
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 5.0, 10.0),
                                                  child: Icon(
                                                    Icons.add_location_sharp,
                                                    color: Color(0xFFC2C4C8),
                                                    size: 24.0,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        // functions
                                                        //     .reconv(getJsonField(
                                                        //   lesDepartsItem,
                                                        //   r'''$.title''',
                                                        // ).toString())
                                                        getJsonField(
                                                          lesDepartsItem,
                                                          r'''$.text''',
                                                        ).toString(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Plus Jakarta Sans',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                      Text(
                                                        // functions
                                                        //     .reconv(getJsonField(
                                                        //   lesDepartsItem,
                                                        //   r'''$.title''',
                                                        // ).toString())
                                                        getJsonField(
                                                          lesDepartsItem,
                                                          r'''$.text''',
                                                        ).toString(),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color: Color(
                                                                  0xFF959595),
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                      Divider(
                                                        thickness: 1.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

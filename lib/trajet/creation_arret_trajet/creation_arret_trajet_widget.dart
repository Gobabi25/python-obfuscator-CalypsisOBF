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
import 'creation_arret_trajet_model.dart';
export 'creation_arret_trajet_model.dart';

class CreationArretTrajetWidget extends StatefulWidget {
  const CreationArretTrajetWidget({
    super.key,
    this.depart,
    this.arrivee,
    this.arrets,
    bool? change,
    this.prevInterface,
    this.index,
    this.idCourse,
    this.serviceId,
  }) : this.change = change ?? false;

  final dynamic depart;
  final dynamic arrivee;
  final List<dynamic>? arrets;
  final bool change;
  final String? prevInterface;
  final int? index;
  final int? idCourse;
  final int? serviceId;

  @override
  State<CreationArretTrajetWidget> createState() =>
      _CreationArretTrajetWidgetState();
}

class _CreationArretTrajetWidgetState extends State<CreationArretTrajetWidget> {
  late CreationArretTrajetModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreationArretTrajetModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.arrets != null && (widget.arrets)!.isNotEmpty) {
        _model.arrets = widget.arrets!.toList().cast<dynamic>();
        setState(() {});
      }
    });

    _model.arretTextController ??= TextEditingController(
        text: widget.index != null
            ? getJsonField(
                widget.arrets?[widget.index!],
                r'''$.display_name''',
              ).toString().toString()
            : '');
    _model.arretFocusNode ??= FocusNode();
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
            'Ajoutez un arret',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/stop.png',
                                            width: 30.0,
                                            height: 30.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller:
                                              _model.arretTextController,
                                          focusNode: _model.arretFocusNode,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            '_model.arretTextController',
                                            Duration(milliseconds: 200),
                                            () async {
                                              _model.arret = false;

                                              _model.departList = functions
                                                  .listeVide()
                                                  .toList()
                                                  .cast<dynamic>();
                                              setState(() {});
                                              await Future.wait([
                                                Future(() async {
                                                  _model.apiResultagbCopy0 =
                                                      await GeoApiFyCall.call(
                                                    q: _model
                                                        .arretTextController
                                                        .text,
                                                  );
                                                }),
                                                Future(() async {
                                                  _model.apiResult9yr =
                                                      await ApisGoBabiGroup
                                                          .getAddressesEnregistreesCall
                                                          .call(
                                                    address: _model
                                                        .arretTextController
                                                        .text,
                                                  );
                                                })
                                              ]);

                                              if ((_model.apiResultagbCopy0
                                                          ?.succeeded ??
                                                      true) &&
                                                  (_model.apiResult9yr
                                                          ?.succeeded ??
                                                      true)) {
                                                _model.departList = functions
                                                    .combinedList(
                                                        getJsonField(
                                                          (_model.apiResultagbCopy0
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
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Arret',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Outfit',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
                                                    ),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Outfit',
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                            suffixIcon: _model
                                                    .arretTextController!
                                                    .text
                                                    .isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      _model.arretTextController
                                                          ?.clear();
                                                      _model.arret = true;
                                                      setState(() {});
                                                      _model.apiResultagbCopy0 =
                                                          await GeoApiFyCall
                                                              .call(
                                                        q: _model
                                                            .arretTextController
                                                            .text,
                                                        // apiKey: FFAppConstants
                                                        //     .hereMapApiKey,
                                                      );

                                                      if ((_model
                                                              .apiResultagbCopy0
                                                              ?.succeeded ??
                                                          true)) {
                                                        _model.departList =
                                                            getJsonField(
                                                          (_model.apiResultagbCopy0
                                                                  ?.jsonBody ??
                                                              ''),
                                                          r'''$.results''',
                                                          true,
                                                        )!
                                                                .toList()
                                                                .cast<
                                                                    dynamic>();
                                                        setState(() {});
                                                      }

                                                      setState(() {});
                                                      setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      color:
                                                          FlutterFlowTheme.of(
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
                                              .arretTextControllerValidator
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
                                      //           widget.index,
                                      //           ParamType.int,
                                      //         ),
                                      //         'depart': serializeParam(
                                      //           widget.depart,
                                      //           ParamType.JSON,
                                      //         ),
                                      //         'arrets': serializeParam(
                                      //           widget.arrets,
                                      //           ParamType.JSON,
                                      //           isList: true,
                                      //         ),
                                      //         'arrivee': serializeParam(
                                      //           widget.arrivee,
                                      //           ParamType.JSON,
                                      //         ),
                                      //       }.withoutNulls,
                                      //     );
                                      //   },
                                      //   // child: Icon(
                                      //   //   Icons.my_location,
                                      //   //   color: Color(0xFF868E96),
                                      //   //   size: 24.0,
                                      //   // ),
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
                            EdgeInsetsDirectional.fromSTEB(0.0, 90.0, 0.0, 0.0),
                        child: Stack(
                          children: [
                            if (_model.arretChoix ?? true)
                              Builder(
                                builder: (context) {
                                  final arretList = _model.departList.toList();
                                  if (arretList.isEmpty) {
                                    return Center(
                                      child: Image.asset(
                                        'assets/images/Order_ride-amico.png',
                                        width: 200.0,
                                        height: 200.0,
                                      ),
                                    );
                                  }
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: arretList.length,
                                    itemBuilder: (context, arretListIndex) {
                                      final arretListItem =
                                          arretList[arretListIndex];
                                      return Visibility(
                                        visible: functions
                                            .doesNotContainRussianCharacters(
                                                getJsonField(
                                          arretListItem,
                                          r'''$.text''',
                                        ).toString()),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            setState(() {
                                              _model.arretTextController?.text =
                                                  //     functions.reconv(getJsonField(
                                                  //   arretListItem,
                                                  //   r'''$.title''',
                                                  // ).toString())
                                                  getJsonField(
                                                arretListItem,
                                                r'''$.text''',
                                              ).toString();
                                              _model.arretTextController
                                                      ?.selection =
                                                  TextSelection.collapsed(
                                                      offset: _model
                                                          .arretTextController!
                                                          .text
                                                          .length);
                                            });
                                            if (widget.index != null) {
                                              _model.updateArretsAtIndex(
                                                widget.index!,
                                                (_) => <String, dynamic>{
                                                  'display_name':

                                                      // functions
                                                      //     .reconv(getJsonField(
                                                      //   arretListItem,
                                                      //   r'''$.title''',
                                                      // ).toString())
                                                      getJsonField(
                                                    arretListItem,
                                                    r'''$.text''',
                                                  ).toString(),
                                                  'latitude': getJsonField(
                                                    arretListItem,
                                                    r'''$.position[1]''',
                                                  ),
                                                  'longitude': getJsonField(
                                                    arretListItem,
                                                    r'''$.position[0]''',
                                                  ),
                                                },
                                              );
                                              setState(() {});
                                            } else {
                                              _model.addToArrets(<String,
                                                  dynamic>{
                                                'display_name':
                                                    //     functions.reconv(getJsonField(
                                                    //   arretListItem,
                                                    //   r'''$.title''',
                                                    // ).toString())
                                                    getJsonField(
                                                  arretListItem,
                                                  r'''$.text''',
                                                ).toString(),
                                                'latitude': getJsonField(
                                                  arretListItem,
                                                  r'''$.position[1]''',
                                                ),
                                                'longitude': getJsonField(
                                                  arretListItem,
                                                  r'''$.position[0]''',
                                                ),
                                              });
                                              setState(() {});
                                            }

                                            if (widget.prevInterface ==
                                                'confirmTrajet') {
                                              context.pushNamed(
                                                'confirmTrajet',
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
                                                    _model.arrets,
                                                    ParamType.JSON,
                                                    isList: true,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            } else {
                                              context.pushNamed('infosTrajet');
                                            }
                                          },
                                          child: Container(
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                5.0, 10.0),
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
                                                          // functions.reconv(
                                                          //     getJsonField(
                                                          //   arretListItem,
                                                          //   r'''$.title''',
                                                          // ).toString())
                                                          getJsonField(
                                                            arretListItem,
                                                            r'''$.text''',
                                                          ).toString(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                        Text(
                                                          // functions.reconv(
                                                          //     getJsonField(
                                                          //   arretListItem,
                                                          //   r'''$.title''',
                                                          // ).toString())
                                                          functions
                                                              .removeRussianCharacters(
                                                                  getJsonField(
                                                            arretListItem,
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

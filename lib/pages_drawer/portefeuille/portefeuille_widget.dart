import 'package:go_babi_drive/flutter_flow/flutter_flow_drop_down.dart';
import 'package:go_babi_drive/flutter_flow/form_field_controller.dart';

import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'portefeuille_model.dart';
export 'portefeuille_model.dart';
import '/flutter_flow/custom_functions.dart' as functions;

class PortefeuilleWidget extends StatefulWidget {
  const PortefeuilleWidget({
    super.key,
    String? statut,
    this.playerid,
    this.idLastTrans,
  }) : this.statut = statut ?? 'none';

  final String statut;
  final String? playerid;
  final String? idLastTrans;

  @override
  State<PortefeuilleWidget> createState() => _PortefeuilleWidgetState();
}

class _PortefeuilleWidgetState extends State<PortefeuilleWidget> {
  late PortefeuilleModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PortefeuilleModel());

    print(
        "LES ELEMENTS == ${widget.statut} ${widget.playerid} ${widget.idLastTrans}");

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          // print(
          //     "LES ELEMENTS == ${widget.statut} ${widget.playerid} ${widget.idLastTrans}");
          if (widget!.statut == 'none') {
          } else if (widget!.statut == 'succes') {
            _model.apiResultt09 = await UpdateStatutPaiementCall.call(
              statuts: widget!.statut,
              id: widget!.idLastTrans,
              playerid: widget!.playerid,
              token: FFAppState().token,
            );

            if ((_model.apiResultt09?.succeeded ?? true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Votre compte a bien été rechargé',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: FlutterFlowTheme.of(context).success,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Erreur lors de la mise a jour du statut succès du paiement',
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
          } else {
            _model.apiResultii1 = await UpdateStatutPaiementCall.call(
              statuts: widget!.statut,
              id: widget!.idLastTrans,
              playerid: widget!.playerid,
              token: FFAppState().token,
            );

            if ((_model.apiResultii1?.succeeded ?? true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Erreur lors du rechargement veuillez réessayer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: FlutterFlowTheme.of(context).error,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Erreur lors de la mise a jour du statut erreur du paiement',
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
          }

          _model.apiResulthut = await ApisGoBabiGroup.walletCheckCall.call(
            token: FFAppState().token,
          );

          if ((_model.apiResulthut?.succeeded ?? true)) {
            _model.totalAmount = getJsonField(
              (_model.apiResulthut?.jsonBody ?? ''),
              r'''$.total_amount''',
            );
            setState(() {});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Une erreur est survenue , veuillez réessayer',
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
        }),
        Future(() async {
          _model.apiResultofb = await ApisGoBabiGroup.walletlistCall.call(
            page: 1,
            token: FFAppState().token,
          );

          if ((_model.apiResultofb?.succeeded ?? true)) {
            _model.data = ApisGoBabiGroup.walletlistCall
                .data(
                  (_model.apiResultofb?.jsonBody ?? ''),
                )!
                .toList()
                .cast<dynamic>();
            _model.pagination = ApisGoBabiGroup.walletlistCall.pagination(
              (_model.apiResultofb?.jsonBody ?? ''),
            );
            setState(() {});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'une erreur est survenue veuillez réessayer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                duration: Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).error,
              ),
            );
          }
        }),
      ]);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(
        "LES ELEMENTS CHANGE == ${widget.statut} ${widget.playerid} ${widget.idLastTrans}");
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
        appBar:
            // Generated code for this AppBar Widget...
            AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              FlutterFlowIconButton(
                borderColor: FlutterFlowTheme.of(context).primary,
                borderRadius: 20,
                borderWidth: 1,
                buttonSize: 40,
                fillColor: FlutterFlowTheme.of(context).primary,
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () async {
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  }
                  context.pushNamed('HomePage');
                },
              ),
              Text(
                'Portefeuille',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 0,
                    ),
              ),
            ].divide(SizedBox(width: 10)),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderColor: FlutterFlowTheme.of(context).primary,
                    borderRadius: 20,
                    borderWidth: 1,
                    buttonSize: 40,
                    fillColor: Colors.white,
                    icon: Icon(
                      Icons.add_card,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 24,
                    ),
                    onPressed: () async {
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      }
                      context.pushNamed('rechargementPage');
                    },
                  ),
                ],
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Solde displonible',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      '${valueOrDefault<String>(
                                        '${_model.totalAmount?.toString()} FCFA',
                                        '-',
                                      )}',
                                      '-',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: Colors.white,
                                          fontSize: 20,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_model.pagination != null)
                    FlutterFlowDropDown<int>(
                      controller: _model.dropDownValueController ??=
                          FormFieldController<int>(
                        _model.dropDownValue ??= 1,
                      ),
                      options: List<int>.from(
                          functions.generatePageListCopy(getJsonField(
                        _model.pagination,
                        r'''$.totalPages''',
                      ))),
                      optionLabels: functions.generatePageList(getJsonField(
                        _model.pagination,
                        r'''$.totalPages''',
                      )),
                      onChanged: (val) async {
                        setState(() => _model.dropDownValue = val);
                        _model.apiResulte9j =
                            await ApisGoBabiGroup.walletlistCall.call(
                          page: _model.dropDownValue,
                          token: FFAppState().token,
                        );
                        if ((_model.apiResulte9j?.succeeded ?? true)) {
                          _model.data = ApisGoBabiGroup.walletlistCall
                              .data(
                                (_model.apiResulte9j?.jsonBody ?? ''),
                              )!
                              .toList()
                              .cast<dynamic>();
                          _model.pagination =
                              ApisGoBabiGroup.walletlistCall.pagination(
                            (_model.apiResulte9j?.jsonBody ?? ''),
                          );
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Erreur lors de la récupération des transactions veuillez réessayer',
                                style: TextStyle(
                                  color: Colors.white,
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
                      width: 120,
                      height: 56,
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Plus Jakarta Sans',
                                letterSpacing: 0,
                              ),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24,
                      ),
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      elevation: 2,
                      borderColor: FlutterFlowTheme.of(context).alternate,
                      borderWidth: 2,
                      borderRadius: 8,
                      margin: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
                      hidesUnderline: true,
                      isOverButton: true,
                      isSearchable: false,
                      isMultiSelect: false,
                    ),
                ].divide(SizedBox(height: 10)),
              ),

              // Generated code for this ListView Widget...
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 200, 20, 0),
                child: Builder(
                  builder: (context) {
                    final transactions = _model.data.toList();
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: transactions.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10),
                      itemBuilder: (context, transactionsIndex) {
                        final transactionsItem =
                            transactions[transactionsIndex];
                        return Padding(
                          padding: EdgeInsets.all(1),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.solidMinusSquare,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getJsonField(
                                                        transactionsItem,
                                                        r'''$.type''',
                                                      ) ==
                                                      getJsonField(
                                                        FFAppState()
                                                            .typeTrans
                                                            .first,
                                                        r'''$.type''',
                                                      )
                                                  ? 'Débit monétaire'
                                                  : 'Crédit monétaire',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                            ),
                                            Text(
                                              getJsonField(
                                                transactionsItem,
                                                r'''$.datetime''',
                                              ).toString(),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 10,
                                                        letterSpacing: 0,
                                                      ),
                                            ),
                                          ].divide(SizedBox(height: 5)),
                                        ),
                                      ].divide(SizedBox(width: 10)),
                                    ),
                                    Text(
                                      '${getJsonField(
                                            transactionsItem,
                                            r'''$.type''',
                                          ) == getJsonField(
                                            FFAppState().typeTrans.first,
                                            r'''$.type''',
                                          ) ? '-' : '+'}${getJsonField(
                                        transactionsItem,
                                        r'''$.amount''',
                                      ).toString()} FCFA',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: getJsonField(
                                                      transactionsItem,
                                                      r'''$.type''',
                                                    ) ==
                                                    getJsonField(
                                                      FFAppState()
                                                          .typeTrans
                                                          .first,
                                                      r'''$.type''',
                                                    )
                                                ? FlutterFlowTheme.of(context)
                                                    .error
                                                : FlutterFlowTheme.of(context)
                                                    .secondary,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.bold,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

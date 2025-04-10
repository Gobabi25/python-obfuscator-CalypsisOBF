import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notif_bulle_model.dart';
export 'notif_bulle_model.dart';

class NotifBulleWidget extends StatefulWidget {
  const NotifBulleWidget({
    super.key,
    String? titre,
    required this.content,
  }) : this.titre = titre ?? 'Go Babi';

  final String titre;
  final String? content;

  @override
  State<NotifBulleWidget> createState() => _NotifBulleWidgetState();
}

class _NotifBulleWidgetState extends State<NotifBulleWidget> {
  late NotifBulleModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotifBulleModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 70.0,
      decoration: BoxDecoration(
        color: Color(0xFF754CE3),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/ic_app_logo.jpg',
                    width: 20.0,
                    height: 20.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  widget.titre,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ].divide(SizedBox(width: 10.0)),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 0.0, 0.0),
              child:
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   children: [
                  Text(
                valueOrDefault<String>(
                  widget.content,
                  '...',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      fontSize: 10.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w300,
                    ),
                //   ),
                // ],
              ),
            ),
          ].divide(SizedBox(height: 5.0)),
        ),
      ),
    );
  }
}

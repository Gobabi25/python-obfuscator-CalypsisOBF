import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'infos_course_widget.dart' show InfosCourseWidget;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InfosCourseModel extends FlutterFlowModel<InfosCourseWidget> {
  ///  Local state fields for this page.

  double? distanceChauffeurClient = 0.0;

  List<String> viaNull = [];
  void addToViaNull(String item) => viaNull.add(item);
  void removeFromViaNull(String item) => viaNull.remove(item);
  void removeAtIndexFromViaNull(int index) => viaNull.removeAt(index);
  void insertAtIndexInViaNull(int index, String item) =>
      viaNull.insert(index, item);
  void updateViaNullAtIndex(int index, Function(String) updateFn) =>
      viaNull[index] = updateFn(viaNull[index]);

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  List<RideRequestRecord>? stackPreviousSnapshot;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

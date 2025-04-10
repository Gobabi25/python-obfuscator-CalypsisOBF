import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'creation_arret_trajet_widget.dart' show CreationArretTrajetWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreationArretTrajetModel
    extends FlutterFlowModel<CreationArretTrajetWidget> {
  ///  Local state fields for this page.

  List<dynamic> arrets = [];
  void addToArrets(dynamic item) => arrets.add(item);
  void removeFromArrets(dynamic item) => arrets.remove(item);
  void removeAtIndexFromArrets(int index) => arrets.removeAt(index);
  void insertAtIndexInArrets(int index, dynamic item) =>
      arrets.insert(index, item);
  void updateArretsAtIndex(int index, Function(dynamic) updateFn) =>
      arrets[index] = updateFn(arrets[index]);

  dynamic arretChoix;

  List<dynamic> departList = [];
  void addToDepartList(dynamic item) => departList.add(item);
  void removeFromDepartList(dynamic item) => departList.remove(item);
  void removeAtIndexFromDepartList(int index) => departList.removeAt(index);
  void insertAtIndexInDepartList(int index, dynamic item) =>
      departList.insert(index, item);
  void updateDepartListAtIndex(int index, Function(dynamic) updateFn) =>
      departList[index] = updateFn(departList[index]);

  bool arret = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for arret widget.
  FocusNode? arretFocusNode;
  TextEditingController? arretTextController;
  String? Function(BuildContext, String?)? arretTextControllerValidator;
  // Stores action output result for [Backend Call - API (heregobabi)] action in arret widget.
  ApiCallResponse? apiResultagbCopy0;
  ApiCallResponse? apiResult9yr;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    arretFocusNode?.dispose();
    arretTextController?.dispose();
  }
}

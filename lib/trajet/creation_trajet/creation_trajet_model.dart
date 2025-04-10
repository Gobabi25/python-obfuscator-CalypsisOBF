import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'creation_trajet_widget.dart' show CreationTrajetWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreationTrajetModel extends FlutterFlowModel<CreationTrajetWidget> {
  ///  Local state fields for this page.

  bool depart = false;

  bool arrivee = false;

  List<dynamic> departList = [];
  void addToDepartList(dynamic item) => departList.add(item);
  void removeFromDepartList(dynamic item) => departList.remove(item);
  void removeAtIndexFromDepartList(int index) => departList.removeAt(index);
  void insertAtIndexInDepartList(int index, dynamic item) =>
      departList.insert(index, item);
  void updateDepartListAtIndex(int index, Function(dynamic) updateFn) =>
      departList[index] = updateFn(departList[index]);

  dynamic departChoix;

  dynamic arriveeChoix;

  List<dynamic> arretChoix = [];
  void addToArretChoix(dynamic item) => arretChoix.add(item);
  void removeFromArretChoix(dynamic item) => arretChoix.remove(item);
  void removeAtIndexFromArretChoix(int index) => arretChoix.removeAt(index);
  void insertAtIndexInArretChoix(int index, dynamic item) =>
      arretChoix.insert(index, item);
  void updateArretChoixAtIndex(int index, Function(dynamic) updateFn) =>
      arretChoix[index] = updateFn(arretChoix[index]);

  bool arret = false;

  dynamic trajet;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for depart widget.
  FocusNode? departFocusNode;
  TextEditingController? departTextController;
  String? Function(BuildContext, String?)? departTextControllerValidator;
  // Stores action output result for [Backend Call - API (heregobabi)] action in depart widget.
  ApiCallResponse? apiResultagb;
  // State field(s) for arrivee widget.
  FocusNode? arriveeFocusNode;
  TextEditingController? arriveeTextController;
  String? Function(BuildContext, String?)? arriveeTextControllerValidator;
  // Stores action output result for [Backend Call - API (heregobabi)] action in arrivee widget.
  ApiCallResponse? apiResultagbCopy;
  ApiCallResponse? apiResult9yr;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    departFocusNode?.dispose();
    departTextController?.dispose();

    arriveeFocusNode?.dispose();
    arriveeTextController?.dispose();
  }
}

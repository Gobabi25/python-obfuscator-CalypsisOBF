import 'package:go_babi_drive/backend/schema/reservations_record.dart';

import '/backend/api_requests/api_calls.dart';
import '/composants/reserv_comp/reserv_comp_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'research_reserv_widget.dart' show ResearchReservWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResearchReservModel extends FlutterFlowModel<ResearchReservWidget> {
  ///  Local state fields for this page.

  String butRecherche = 'startAddress';

  DateTime? heureSelect;

  DateTime? dateSelect;

  ReservationsRecord? dejaC;

  bool charge = false;

  List<dynamic> listeReservations = [];
  void addToListeReservations(dynamic item) => listeReservations.add(item);
  void removeFromListeReservations(dynamic item) =>
      listeReservations.remove(item);
  void removeAtIndexFromListeReservations(int index) =>
      listeReservations.removeAt(index);
  void insertAtIndexInListeReservations(int index, dynamic item) =>
      listeReservations.insert(index, item);
  void updateListeReservationsAtIndex(int index, Function(dynamic) updateFn) =>
      listeReservations[index] = updateFn(listeReservations[index]);

  String? searchAddress = ' ';

  int nbrPage = 1;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for locateDrop widget.
  int? locateDropValue;
  FormFieldController<int>? locateDropValueController;
  // Stores action output result for [Backend Call - API (rechercher reservation)] action in locateDrop widget.
  ApiCallResponse? apiResult55cCopy;
  // State field(s) for heureDrop widget.
  int? heureDropValue;
  FormFieldController<int>? heureDropValueController;
  // Stores action output result for [Backend Call - API (rechercher reservation)] action in heureDrop widget.
  ApiCallResponse? apiResultf24Copy2;
  // State field(s) for dateDrop widget.
  int? dateDropValue;
  FormFieldController<int>? dateDropValueController;
  // Stores action output result for [Backend Call - API (rechercher reservation)] action in dateDrop widget.
  ApiCallResponse? apiResultf24CopyCopy;
  // State field(s) for addressDrop widget.
  int? addressDropValue;
  FormFieldController<int>? addressDropValueController;
  // Stores action output result for [Backend Call - API (rechercher reservation)] action in addressDrop widget.
  ApiCallResponse? apiResult1hbCopy;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (rechercher reservation)] action in TextField widget.
  ApiCallResponse? apiResult1hb;
  // Stores action output result for [Backend Call - API (rechercher reservation)] action in IconButton widget.
  ApiCallResponse? apiResult55c;
  DateTime? datePicked1;
  // Stores action output result for [Backend Call - API (rechercher reservation)] action in IconButton widget.
  ApiCallResponse? apiResultf24;
  DateTime? datePicked2;
  // Stores action output result for [Backend Call - API (rechercher reservation)] action in IconButton widget.
  ApiCallResponse? apiResultf24Copy;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

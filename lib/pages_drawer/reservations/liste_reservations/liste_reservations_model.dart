import 'package:go_babi_drive/backend/schema/reservations_record.dart';

import '/backend/backend.dart';
import '/composants/reserv_comp/reserv_comp_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'liste_reservations_widget.dart' show ListeReservationsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ListeReservationsModel extends FlutterFlowModel<ListeReservationsWidget> {
  ///  Local state fields for this page.

  String enattente = 'new_booking_request';

  String encours = 'in_progress';

  String acceptee = 'accepted';

  ReservationsRecord? dejaC;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}

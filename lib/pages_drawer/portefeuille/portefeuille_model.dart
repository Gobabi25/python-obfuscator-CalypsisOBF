import 'package:go_babi_drive/flutter_flow/form_field_controller.dart';

import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'portefeuille_widget.dart' show PortefeuilleWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class PortefeuilleModel extends FlutterFlowModel<PortefeuilleWidget> {
  ///  Local state fields for this page.

  int? totalAmount = 0;
  List<dynamic> data = [];
  void addToData(dynamic item) => data.add(item);
  void removeFromData(dynamic item) => data.remove(item);
  void removeAtIndexFromData(int index) => data.removeAt(index);
  void insertAtIndexInData(int index, dynamic item) => data.insert(index, item);
  void updateDataAtIndex(int index, Function(dynamic) updateFn) =>
      data[index] = updateFn(data[index]);

  dynamic pagination;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (wallet check)] action in portefeuille widget.
  ApiCallResponse? apiResulthut;
  // State field(s) for ListView widget.
  // Stores action output result for [Backend Call - API (update statut paiement)] action in portefeuille widget.
  ApiCallResponse? apiResultt09;
  // Stores action output result for [Backend Call - API (wallet check)] action in portefeuille widget.
  ApiCallResponse? apiResulthutCopy;
  // Stores action output result for [Backend Call - API (update statut paiement)] action in portefeuille widget.
  ApiCallResponse? apiResultii1;
  // State field(s) for ListView widget.
  ApiCallResponse? apiResultofb;
  ApiCallResponse? apiResulte9j;
  PagingController<ApiPagingParams, dynamic>? listViewPagingController;
  int? dropDownValue;
  FormFieldController<int>? dropDownValueController;
  Function(ApiPagingParams nextPageMarker)? listViewApiCall;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    listViewPagingController?.dispose();
  }

  /// Additional helper methods.
  PagingController<ApiPagingParams, dynamic> setListViewController(
    Function(ApiPagingParams) apiCall,
  ) {
    listViewApiCall = apiCall;
    return listViewPagingController ??= _createListViewController(apiCall);
  }

  PagingController<ApiPagingParams, dynamic> _createListViewController(
    Function(ApiPagingParams) query,
  ) {
    final controller = PagingController<ApiPagingParams, dynamic>(
      firstPageKey: ApiPagingParams(
        nextPageNumber: 0,
        numItems: 0,
        lastResponse: null,
      ),
    );
    return controller..addPageRequestListener(listViewWalletlistPage);
  }

  void listViewWalletlistPage(ApiPagingParams nextPageMarker) =>
      listViewApiCall!(nextPageMarker).then((listViewWalletlistResponse) {
        final pageItems = (getJsonField(
                  listViewWalletlistResponse.jsonBody,
                  r'''$.data''',
                ) ??
                [])
            .toList() as List;
        final newNumItems = nextPageMarker.numItems + pageItems.length;
        listViewPagingController?.appendPage(
          pageItems,
          (pageItems.length > 0)
              ? ApiPagingParams(
                  nextPageNumber: nextPageMarker.nextPageNumber + 1,
                  numItems: newNumItems,
                  lastResponse: listViewWalletlistResponse,
                )
              : null,
        );
      });
}

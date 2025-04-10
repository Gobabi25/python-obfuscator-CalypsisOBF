import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Apis Go Babi Group Code

class ApisGoBabiGroup {
  static String getBaseUrl() => 'https://appgobabi.com/api/';
  // static String getBaseUrl() =>
  // 'https://appgobabi.lesjardinsdubeki.com/html/api/';
  static Map<String, String> headers = {};
  static LoginCall loginCall = LoginCall();
  static DriverRegisterCall driverRegisterCall = DriverRegisterCall();
  static CurrentRideRequestCall currentRideRequestCall =
      CurrentRideRequestCall();
  static UpdateStatusCall updateStatusCall = UpdateStatusCall();
  static UpdateUserConnexionCall updateUserConnexionCall =
      UpdateUserConnexionCall();
  static UpdateUserLocalisationCall updateUserLocalisationCall =
      UpdateUserLocalisationCall();
  static RideRequestUpdateCall rideRequestUpdateCall = RideRequestUpdateCall();
  static UserDetailCall userDetailCall = UserDetailCall();
  static UpdateUserDetailCall updateUserDetailCall = UpdateUserDetailCall();
  static WalletCheckCall walletCheckCall = WalletCheckCall();
  static DeleteUserCall deleteUserCall = DeleteUserCall();
  static UpdateCarDetailsCall updateCarDetailsCall = UpdateCarDetailsCall();
  static ChangePasswordCall changePasswordCall = ChangePasswordCall();
  static GetServicesCall getServicesCall = GetServicesCall();
  static RideRequestRespondCall rideRequestRespondCall =
      RideRequestRespondCall();
  static CompleteRideCall completeRideCall = CompleteRideCall();
  static GetRiderRequestListCall getRiderRequestListCall =
      GetRiderRequestListCall();
  static SaveSosCall saveSosCall = SaveSosCall();
  static GetSosListCall getSosListCall = GetSosListCall();
  static SosDeleteCall sosDeleteCall = SosDeleteCall();
  static DocumentListeCall documentListeCall = DocumentListeCall();
  static DriverDocumentListeCall driverDocumentListeCall =
      DriverDocumentListeCall();
  static UploadDocumentCall uploadDocumentCall = UploadDocumentCall();
  static DriverDocumentDeleteCall driverDocumentDeleteCall =
      DriverDocumentDeleteCall();
  static EstimatePriceWithDistanceCall estimatePriceWithDistanceCall =
      EstimatePriceWithDistanceCall();
  static CommanderCourseCall commanderCourseCall = CommanderCourseCall();
  static BizaoInsertRequestCall bizaoInsertRequestCall =
      BizaoInsertRequestCall();
  static ModifierStopEtDestinationCall modifierStopEtDestinationCall =
      ModifierStopEtDestinationCall();
  static WalletlistCall walletlistCall = WalletlistCall();
  static RideRequestUpdateProCall rideRequestUpdateProCall =
      RideRequestUpdateProCall();
  static ZonesPourClusterCall zonesPourClusterCall = ZonesPourClusterCall();
  static ListeReservationsCall listeReservationsCall = ListeReservationsCall();
  static ChangeStatutReservationCall changeStatutReservationCall =
      ChangeStatutReservationCall();
  static DetailReservationCall detailReservationCall = DetailReservationCall();
  static DesisterReservationCall desisterReservationCall =
      DesisterReservationCall();
  static RechercherReservationCall rechercherReservationCall =
      RechercherReservationCall();
  static GetAddressesEnregistreesCall getAddressesEnregistreesCall =
      GetAddressesEnregistreesCall();
  static SaveVersionCall saveVersionCall = SaveVersionCall();
  static SaveConnexionCall saveConnexionCall = SaveConnexionCall();
}

class RideRequestUpdateProCall {
  Future<ApiCallResponse> call({
    String? status = '',
    String? rideId = '',
    String? token = '',
    String? cancelBy = '',
    String? reason = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
 
  "status": "${status}",
  "cancel_by": "${cancelBy}",
  "reason": "${reason}",
 
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Ride request update',
      apiUrl: '${baseUrl}riderequest-updatepro/${rideId}',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SaveVersionCall {
  Future<ApiCallResponse> call({
    String? version = '',
    int? id,
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "app_version": "${version}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'save version',
      apiUrl: '${baseUrl}save-app-version/${id}',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SaveConnexionCall {
  Future<ApiCallResponse> call({
    int? id,
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'save connexion',
      apiUrl: '${baseUrl}driver-online/${id}',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAddressesEnregistreesCall {
  Future<ApiCallResponse> call({
    String? address = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'get addresses enregistrees',
      apiUrl: '${baseUrl}get-address',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'address': address,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class LoginCall {
  Future<ApiCallResponse> call({
    String? contactNumber = '',
    String? password = '',
    String? playerId = '',
    String? userType = 'driver',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();
    print("==playerId== ${playerId}");
    final ffApiRequestBody = '''
{
  "contact_number": "${contactNumber}",
  "password": "${password}",
  "player_id": "${playerId}",
  "user_type": "${userType}"
}''';

    print("====LOGIN1==== ${ffApiRequestBody}");
    return ApiManager.instance.makeApiCall(
      callName: 'login',
      apiUrl: '${baseUrl}login',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic? estEnLigne(dynamic response) => getJsonField(
        response,
        r'''$.data.is_online''',
      );

  dynamic? estDispo(dynamic response) => getJsonField(
        response,
        r'''$.data.is_available''',
      );

  dynamic? statut(dynamic response) => getJsonField(
        response,
        r'''$.data.status''',
      );
}

class RechercherReservationCall {
  Future<ApiCallResponse> call({
    String? date = '',
    String? time = '',
    String? startAddress = '',
    String? longitude = '',
    String? latitude = '',
    String? page = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'rechercher reservation',
      apiUrl: '${baseUrl}reservations/filter',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'date': date,
        'time': time,
        'start_address': startAddress,
        'longitude': longitude,
        'latitude': latitude,
        'page': page,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? lesReserv(dynamic response) => getJsonField(
        response,
        r'''$.reservations.data''',
        true,
      ) as List?;
  int? nbrPages(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.reservations.last_page''',
      ));
}

class DesisterReservationCall {
  Future<ApiCallResponse> call({
    int? id,
    String? token = '',
    String? status = '',
    int? driverId,
    String? cancelBy = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "id": ${id},
  "status": "${status}",
  "driver_id": ${driverId},
  "cancel_by": "${cancelBy}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'desister reservation',
      apiUrl: '${baseUrl}updateproresvation/${id}',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DriverRegisterCall {
  Future<ApiCallResponse> call({
    String? firstName = '',
    String? lastName = '',
    String? username = '',
    String? email = '',
    String? userType = '',
    String? contactNumber = '',
    String? password = '',
    String? playerId = '',
    String? idCode = '',
    String? carProductionYear = '',
    String? carModel = '',
    String? carColor = '',
    String? carPlateNumber = '',
    dynamic? userDetailJson,
    int? serviceId,
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    // final userDetail = _serializeJson(userDetailJson);
    final userDetail = {
      "car_model": "${carModel}",
      "car_color": "${carColor}",
      "car_plate_number": "${carPlateNumber}",
      "car_production_year": "${carProductionYear}",
    };

    final ffApiRequestBody = '''
{
  "first_name": "${firstName}",
  "last_name": "${lastName}",
  "username": "${username}",
  "email": "${email}",
  "user_type": "driver",
  "contact_number": "${contactNumber}",
  "password": "${password}",
  "player_id": "${playerId}",
  "user_detail": {
  "car_model":"${carModel}",
  "car_color":"${carColor}",
  "car_plate_number":"${carPlateNumber}",
  "car_production_year":"${carProductionYear}",
  },
  "service_id": ${serviceId},
  "id_code": "${idCode}"
}''';
    print(ffApiRequestBody.toString());
    return ApiManager.instance.makeApiCall(
      callName: 'driver  register',
      apiUrl: '${baseUrl}driver-register',
      callType: ApiCallType.POST,
      headers: {},
      params: {
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "user_type": "driver",
        "contact_number": contactNumber,
        "password": password,
        "player_id": playerId,
        "user_detail": userDetail,
        "service_id": serviceId,
        "id_code": idCode
      },
      // body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class WalletlistCall {
  Future<ApiCallResponse> call({
    int? page,
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'walletlist',
      apiUrl: '${baseUrl}wallet-list',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'page': page,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic? pagination(dynamic response) => getJsonField(
        response,
        r'''$.pagination''',
      );
  List? data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;

  List<String>? transType(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<int>? transAmount(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].amount''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
}

class ListeReservationsCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'liste reservations',
      apiUrl: '${baseUrl}/liste-reservation',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ChangeStatutReservationCall {
  Future<ApiCallResponse> call({
    int? id,
    int? driverId,
    String? statuts = '',
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "driver_id": ${driverId},
  "status": "${statuts}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'change statut reservation',
      apiUrl: '${baseUrl}updateReservationstatus/${id}',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DetailReservationCall {
  Future<ApiCallResponse> call({
    int? id,
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "id": ${id}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'detail reservation',
      apiUrl: '${baseUrl}getReservationsById',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ZonesPourClusterCall {
  Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'zones pour cluster',
      apiUrl: '${baseUrl}getGroupedOrdersByZone3',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CurrentRideRequestCall {
  Future<ApiCallResponse> call({
    String? token = '',
    String? id = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'current ride request',
      apiUrl: '${baseUrl}current-riderequestdriver',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'driver_id': id,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? statut(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
}

class UpdateStatusCall {
  Future<ApiCallResponse> call({
    String? status = '',
    int? isOnline,
    int? isAvailable,
    String? token = '',
    String? latitude = '',
    String? longitude = '',
    int? id,
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "status": "${status}",
  "is_online": ${isOnline},
  "is_available": ${isAvailable},
  "latitude": ${latitude},
  "longitude": ${longitude},
  "id":${id},
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'update status',
      apiUrl: '${baseUrl}update-user-status',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateUserConnexionCall {
  Future<ApiCallResponse> call({
    String? status = '',
    int? isOnline,
    int? isAvailable,
    String? token = '',
    int? id,
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();
    return ApiManager.instance.makeApiCall(
      callName: 'update user connexion',
      apiUrl: '${baseUrl}update-user-connexion',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'status': status,
        'is_online': isOnline,
        'is_available': isAvailable,
        'id': id,
      },
      // body: ffApiRequestBody,
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateUserLocalisationCall {
  Future<ApiCallResponse> call({
    String? longitude = '',
    String? latitude = '',
    String? token = '',
    int? id,
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();
    print("==object longitude $longitude latitude $latitude");
    return ApiManager.instance.makeApiCall(
      callName: 'update user localisation',
      apiUrl: '${baseUrl}location/update',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'user_id': id,
        'latitude': latitude,
        'longitude': longitude,
      },
      // body: ffApiRequestBody,
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class RideRequestUpdateCall {
  Future<ApiCallResponse> call({
    int? rideId,
    String? token = '',
    String? status = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "id": ${rideId},
  "status": "${status}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ride request update',
      apiUrl: '${baseUrl}riderequest-update/${rideId}',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UserDetailCall {
  Future<ApiCallResponse> call({
    int? userId,
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'user detail',
      apiUrl: '${baseUrl}user-detail',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'id': userId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic? lesDonnees(dynamic response) => getJsonField(
        response,
        r'''$.data''',
      );
  dynamic? infosCar(dynamic response) => getJsonField(
        response,
        r'''$.data.user_detail''',
      );
  dynamic? infosService(dynamic response) => getJsonField(
        response,
        r'''$.data.driver_service''',
      );

  dynamic? carModel(dynamic response) => getJsonField(
        response,
        r'''$.data.user_detail.car_model''',
      );

  dynamic? carColor(dynamic response) => getJsonField(
        response,
        r'''$.data.user_detail.car_color''',
      );

  dynamic? carPlateNumber(dynamic response) => getJsonField(
        response,
        r'''$.data.user_detail.car_plate_number''',
      );

  dynamic? carProdYear(dynamic response) => getJsonField(
        response,
        r'''$.data.user_detail.car_production_year''',
      );
}

class UpdateUserDetailCall {
  Future<ApiCallResponse> call({
    String? id,
    String? contactNumber = '',
    dynamic? userDetailJson,
    String? email = '',
    String? username = '',
    String? token = '',
    String? firstName = '',
    String? lastName = '',
    String? address = '',
    String? homeLongitude = '',
    String? homeLatitude = '',
    String? serviceId = '',
    FFUploadedFile? profileImage,
    String? idCode = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final userDetail = _serializeJson(userDetailJson);
    print("==userDetail== $userDetail  $id $token");

    return ApiManager.instance.makeApiCall(
      callName: 'update user detail',
      apiUrl: '${baseUrl}update-profile/$id',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'first_name': firstName,
        'last_name': lastName,
        'id': id,
        'contact_number': contactNumber,
        'address': address,
        'home_latitude': homeLatitude,
        'home_longitude': homeLongitude,
        'profile_image': profileImage,
        'id_code': idCode,
        'username': "$firstName $lastName",
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class WalletCheckCall {
  Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'wallet check',
      apiUrl: '${baseUrl}wallet-detail',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  double? leMin(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.min_amount_to_get_ride''',
      ));
  double? djai(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.total_amount''',
      ));
}

class DeleteUserCall {
  Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'delete user',
      apiUrl: '${baseUrl}delete-user-account',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer  ${token}',
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateCarDetailsCall {
  Future<ApiCallResponse> call({
    String? carModel = '',
    int? id,
    String? token = '',
    String? carColor = '',
    String? carProductionYear = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    // final carDetails = _serializeJson(carDetailsJson);
    final ffApiRequestBody = '''
{
  "car_model": ${carModel},
  "car_color": ${carColor},
  "car_production_year": ${carProductionYear}
}''';

    print("car detail : $carColor");
    return ApiManager.instance.makeApiCall(
      callName: 'update car details',
      apiUrl: '${baseUrl}update-car-info/${id},',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        "car_model": carModel,
        "car_color": carColor,
        "car_production_year": carProductionYear
      },
      // body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ChangePasswordCall {
  Future<ApiCallResponse> call({
    String? token = '',
    String? oldPassword = '',
    String? newPassword = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "old_password": "${oldPassword}",
  "new_password": "${newPassword}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'change password ',
      apiUrl: '${baseUrl}change-password',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetServicesCall {
  Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'get services ',
      apiUrl: '${baseUrl}get-service',
      callType: ApiCallType.GET,
      headers: {
        'authorization': 'Bearer ${token}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class RideRequestRespondCall {
  Future<ApiCallResponse> call({
    String? token = '',
    int? id,
    int? driverId,
    int? isAccept,
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
      "id": ${id},
      "driver_id":${driverId} ,
      "is_accept":${isAccept} 
    }''';
    return ApiManager.instance.makeApiCall(
      callName: 'ride request respond',
      apiUrl: '${baseUrl}riderequest-respond',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CompleteRideCall {
  Future<ApiCallResponse> call({
    String? token = '',
    int? id,
    int? serviceId,
    String? endLatitude = '',
    String? endLongitude = '',
    String? endAddress = '',
    String? distance = '',
    String? extraCharges = '',
    String? extraChargesAmount = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "id": ${id},
  "service_id": ${serviceId},
  "end_latitude": "${endLatitude}",
  "end_longitude": "${endLongitude}",
  "end_address": "${endAddress}",
  "distance": "${distance}",
  "extra_charges": "${extraCharges}",
  "extra_charges_amount": "${extraChargesAmount}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'complete ride',
      apiUrl: '${baseUrl}complete-riderequest',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetRiderRequestListCall {
  Future<ApiCallResponse> call({
    int? page,
    int? driverId,
    String? status = '',
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'get rider request list',
      apiUrl: '${baseUrl}riderequest-list',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'page': page,
        'driver_id': driverId,
        'status': status,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? laListe(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class SaveSosCall {
  Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'save sos',
      apiUrl: '${baseUrl}save-sos',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetSosListCall {
  Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'get sos list',
      apiUrl: '${baseUrl}sos-list',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SosDeleteCall {
  Future<ApiCallResponse> call({
    String? token = '',
    int? id,
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'sos delete',
      apiUrl: '${baseUrl}sos-delete/${id}',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DocumentListeCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'document liste',
      apiUrl: '${baseUrl}document-list',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? laListe(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
  List? lesIds(dynamic response) => getJsonField(
        response,
        r'''$.data[:].id''',
        true,
      ) as List?;
  List<String>? lesNoms(dynamic response) => (getJsonField(
        response,
        r'''$.data[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class DriverDocumentListeCall {
  Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'driver document liste',
      apiUrl: '${baseUrl}driver-document-list',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? documents(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class UploadDocumentCall {
  Future<ApiCallResponse> call({
    String? token = '',
    int? driverId,
    int? documentId,
    int? isVerified = 0,
    FFUploadedFile? driverDocument,
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'upload document',
      apiUrl: '${baseUrl}driver-document-save',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'driver_id': driverId,
        'document_id': documentId,
        'is_verified': isVerified,
        'driver_document': driverDocument,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DriverDocumentDeleteCall {
  Future<ApiCallResponse> call({
    String? token = '',
    int? id,
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'driver document delete',
      apiUrl: '${baseUrl}driver-document-delete/${id}',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class EstimatePriceWithDistanceCall {
  Future<ApiCallResponse> call({
    String? distance = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'Estimate price with distance',
      apiUrl: '${baseUrl}price-distance',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'distance': distance,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic? premierService(dynamic response) => getJsonField(
        response,
        r'''$[0]''',
      );
  dynamic? deuxiemeService(dynamic response) => getJsonField(
        response,
        r'''$[1]''',
      );
}

class CommanderCourseCall {
  Future<ApiCallResponse> call({
    String? lastName = '',
    String? contactNumber = '',
    String? serviceId = '',
    String? datetime = '',
    String? startLatitude = '',
    String? startLongitude = '',
    String? startAddress = '',
    String? endLatitude = '',
    String? endLongitude = '',
    String? endAddress = '',
    String? driverId = '',
    String? status = '',
    int? montant,
    String? paymentType = '',
    String? arretCoordonnee = '',
    String? firstName = '',
    String? token = '',
    String? distance = '',
    String? duration = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "first_name": "${firstName}",
  "last_name": "${lastName}",
  "contact_number": "${contactNumber}",
  "service_id": "${serviceId}",
  "datetime": "${datetime}",
  "start_latitude": "${startLatitude}",
  "start_longitude": "${startLongitude}",
  "start_address": "${startAddress}",
  "end_latitude": "${endLatitude}",
  "end_longitude": "${endLongitude}",
  "end_address": "${endAddress}",
  "driver_id": "${driverId}",
  "status": "${status}",
  "montant": ${montant},
  "payment_type": "${paymentType}",
  "arret_coordonnee": "${arretCoordonnee}",
  "distance": "${distance}",
  "duration": "${duration}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Commander course',
      apiUrl: '${baseUrl}commande',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class StatRatingCall {
  static Future<ApiCallResponse> call({
    int? driverId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'stat rating',
      apiUrl: 'http://appgobabi.com/api/apigobabi/mobileP.php/executeOperation',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'typeoperation': "getByDriverId",
        'driver_id': driverId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static double? rating(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.average_rating''',
      ));
}

class StatCoursesMontantCall {
  static Future<ApiCallResponse> call({
    String? status = '',
    int? driverId,
    String? startDate = '',
    String? endDate = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'stat courses montant',
      apiUrl: 'http://appgobabi.com/api/apigobabi/mobileP.php/executeOperation',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'typeoperation': "getStatusDriver",
        'status': status,
        'start_date': startDate,
        'end_date': endDate,
        'driver_id': driverId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? nbrCourses(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.rides[:].nombre_courses''',
      ));
  static String? montant(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.rides[:].total_montant''',
      ));
}

class UpdateStatutPaiementCall {
  static Future<ApiCallResponse> call({
    String? typeoperation = 'update',
    String? statuts = '',
    String? id = '',
    String? playerid = '',
    String? token = '',
  }) async {
    print("LES ELEMENTS == ${statuts} ${playerid} ${id}");
    final baseUrl = ApisGoBabiGroup.getBaseUrl();
    return ApiManager.instance.makeApiCall(
      callName: 'update statut paiement',
      apiUrl: '${baseUrl}apigobabi/bizao.php/executeOperationp',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'typeoperation': typeoperation,
        'statuts': statuts,
        'id': id,
        'playerid': playerid,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BizaoInsertRequestCall {
  Future<ApiCallResponse> call({
    String? typeoperation = 'insert',
    int? idDriver,
    String? statuts = '',
    String? operateur = '',
    int? montant,
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'bizao insert request',
      apiUrl: '${baseUrl}apigobabi/bizao.php/executeOperationp',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'typeoperation': typeoperation,
        'id_driver': idDriver,
        'operateur': operateur,
        'statuts': statuts,
        'montant': montant,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ModifierStopEtDestinationCall {
  Future<ApiCallResponse> call({
    int? rideRequestId,
    int? serviceId,
    String? distance = '',
    String? duration = '',
    String? waitingTime = '',
    String? extraChargesAmount = '',
    String? coupon = '',
    String? arretCoordonnee = '',
    String? endLatitude = '',
    String? endLongitude = '',
    String? endAdress = '',
    String? token = '',
  }) async {
    final baseUrl = ApisGoBabiGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "ride_request_id": "${rideRequestId}",
  "service_id": "${serviceId}",
  "distance": "${distance}",
  "duration": "${duration}",
  "waiting_time": "${waitingTime}",
  "extra_charges_amount": "${extraChargesAmount}",
  "coupon": "${coupon}",
  "arret_coordonnee": "${arretCoordonnee}",
  "end_latitude": "${endLatitude}",
  "end_longitude": "${endLongitude}",
  "end_address": "${endAdress}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Modifier stop et destination',
      apiUrl: '${baseUrl}calculate-Stopplus',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Apis Go Babi Group Code

class HeregobabiCall {
  static Future<ApiCallResponse> call({
    String? q = '',
    String? apiKey = '',
    String? at = '5.397516500000022,-3.9453121220884593',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'heregobabi',
      apiUrl: 'https://autosuggest.search.hereapi.com/v1/autosuggest',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'q': q,
        'apiKey': apiKey,
        'at': at,
        'lang': "fr",
        'in': "countryCode:CIV",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GeoApiFyCall {
  static Future<ApiCallResponse> call({
    String? q = '',
    String? apiKey = '',
    String? at = '5.397516500000022,-3.9453121220884593',
  }) async {
    final ffApiRequestBody = '''
{
  "part": "${q}"
  
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'geoapify',
      // apiUrl: 'https://api.geoapify.com/v1/geocode/autocomplete',
      apiUrl: 'https://yangosuggest.prod.ndbsoft.ovh/suggest',
      callType: ApiCallType.POST,
      headers: {},
      body: ffApiRequestBody,
      params: {
        // 'text': q,
        // 'apiKey': "8d589e1964a74281bf3dea4a648f5e2c",
        // 'bias': "proximity:$at",
        // 'lang': "fr",
        // 'filter': "countrycode:ci",
        // 'format': "json"
      },
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReverseGeocodeCall {
  static Future<ApiCallResponse> call({
    String? at = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'reverse geocode',
      apiUrl: 'https://revgeocode.search.hereapi.com/v1/revgeocode',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'limit': 1,
        'at': at,
        'lang': "fr-FR",
        'apiKey': "EvTffyyGJgaLRJ0AcT1Ecqx5KzGJ36PTmcVZEBzVI2Y",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? displayname(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.items[:].address.label''',
      ));
}

class ApiwaveCall {
  static Future<ApiCallResponse> call({
    String? amount = '',
    String? currency = 'XOF',
    String? errorUrl = 'https://projitek-crm.com/error.html',
    String? successUrl = 'https://projitek-crm.com/success.html',
    int? id,
    int? playerId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'apiwave',
      apiUrl: 'https://projitek-crm.com/pay/apiwave2.php',
      callType: ApiCallType.POST,
      headers: {},
      params: {
        'amount': amount,
        'currency': currency,
        'error_url': errorUrl,
        'success_url': successUrl,
        'id': id,
        'player_id': playerId,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

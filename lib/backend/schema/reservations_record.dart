import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReservationsRecord extends FirestoreRecord {
  ReservationsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "driver_lastname" field.
  String? _driverLastname;
  String get driverLastname => _driverLastname ?? '';
  bool hasDriverLastname() => _driverLastname != null;

  // "driver_contact" field.
  String? _driverContact;
  String get driverContact => _driverContact ?? '';
  bool hasDriverContact() => _driverContact != null;

  // "driver_immatriculation" field.
  String? _driverImmatriculation;
  String get driverImmatriculation => _driverImmatriculation ?? '';
  bool hasDriverImmatriculation() => _driverImmatriculation != null;

  // "driver_marque" field.
  String? _driverMarque;
  String get driverMarque => _driverMarque ?? '';
  bool hasDriverMarque() => _driverMarque != null;

  // "driver_color" field.
  String? _driverColor;
  String get driverColor => _driverColor ?? '';
  bool hasDriverColor() => _driverColor != null;

  // "service_name" field.
  String? _serviceName;
  String get serviceName => _serviceName ?? '';
  bool hasServiceName() => _serviceName != null;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  bool hasId() => _id != null;

  // "distance" field.
  double? _distance;
  double get distance => _distance ?? 0.0;
  bool hasDistance() => _distance != null;

  // "montant" field.
  int? _montant;
  int get montant => _montant ?? 0;
  bool hasMontant() => _montant != null;

  // "duration" field.
  int? _duration;
  int get duration => _duration ?? 0;
  bool hasDuration() => _duration != null;

  // "end_latitude" field.
  double? _endLatitude;
  double get endLatitude => _endLatitude ?? 0.0;
  bool hasEndLatitude() => _endLatitude != null;

  // "end_longitude" field.
  double? _endLongitude;
  double get endLongitude => _endLongitude ?? 0.0;
  bool hasEndLongitude() => _endLongitude != null;

  // "start_latitude" field.
  double? _startLatitude;
  double get startLatitude => _startLatitude ?? 0.0;
  bool hasStartLatitude() => _startLatitude != null;

  // "start_longitude" field.
  double? _startLongitude;
  double get startLongitude => _startLongitude ?? 0.0;
  bool hasStartLongitude() => _startLongitude != null;

  // "driver_id" field.
  int? _driverId;
  int get driverId => _driverId ?? 0;
  bool hasDriverId() => _driverId != null;

  // "rider_id" field.
  int? _riderId;
  int get riderId => _riderId ?? 0;
  bool hasRiderId() => _riderId != null;

  // "driver_name" field.
  String? _driverName;
  String get driverName => _driverName ?? '';
  bool hasDriverName() => _driverName != null;

  // "service_id" field.
  int? _serviceId;
  int get serviceId => _serviceId ?? 0;
  bool hasServiceId() => _serviceId != null;

  // "start_address" field.
  String? _startAddress;
  String get startAddress => _startAddress ?? '';
  bool hasStartAddress() => _startAddress != null;

  // "end_address" field.
  String? _endAddress;
  String get endAddress => _endAddress ?? '';
  bool hasEndAddress() => _endAddress != null;

  // "arret_coordonnee" field.
  String? _arretCoordonnee;
  String get arretCoordonnee => _arretCoordonnee ?? '';
  bool hasArretCoordonnee() => _arretCoordonnee != null;

  // "driver_photo" field.
  String? _driverPhoto;
  String get driverPhoto => _driverPhoto ?? '';
  bool hasDriverPhoto() => _driverPhoto != null;

  // "rider_photo" field.
  String? _riderPhoto;
  String get riderPhoto => _riderPhoto ?? '';
  bool hasRiderPhoto() => _riderPhoto != null;

  // "other_rider_data" field.
  String? _otherRiderData;
  String get otherRiderData => _otherRiderData ?? '';
  bool hasOtherRiderData() => _otherRiderData != null;

  // "rider_firstname" field.
  String? _riderFirstname;
  String get riderFirstname => _riderFirstname ?? '';
  bool hasRiderFirstname() => _riderFirstname != null;

  // "rider_lastname" field.
  String? _riderLastname;
  String get riderLastname => _riderLastname ?? '';
  bool hasRiderLastname() => _riderLastname != null;

  // "rider_contact" field.
  String? _riderContact;
  String get riderContact => _riderContact ?? '';
  bool hasRiderContact() => _riderContact != null;

  // "date" field.
  String? _date;
  String get date => _date ?? '';
  bool hasDate() => _date != null;

  // "heure" field.
  String? _heure;
  String get heure => _heure ?? '';
  bool hasHeure() => _heure != null;

  // "dateheure" field.
  DateTime? _dateheure;
  DateTime? get dateheure => _dateheure;
  bool hasDateheure() => _dateheure != null;

  void _initializeFields() {
    _status = snapshotData['status'] as String?;
    _driverLastname = snapshotData['driver_lastname'] as String?;
    _driverContact = snapshotData['driver_contact'] as String?;
    _driverImmatriculation = snapshotData['driver_immatriculation'] as String?;
    _driverMarque = snapshotData['driver_marque'] as String?;
    _driverColor = snapshotData['driver_color'] as String?;
    _serviceName = snapshotData['service_name'] as String?;
    _id = castToType<int>(snapshotData['id']);
    _distance = castToType<double>(snapshotData['distance']);
    _montant = castToType<int>(snapshotData['montant']);
    _duration = castToType<int>(snapshotData['duration']);
    _endLatitude = castToType<double>(snapshotData['end_latitude']);
    _endLongitude = castToType<double>(snapshotData['end_longitude']);
    _startLatitude = castToType<double>(snapshotData['start_latitude']);
    _startLongitude = castToType<double>(snapshotData['start_longitude']);
    _driverId = castToType<int>(snapshotData['driver_id']);
    _riderId = castToType<int>(snapshotData['rider_id']);
    _driverName = snapshotData['driver_name'] as String?;
    _serviceId = castToType<int>(snapshotData['service_id']);
    _startAddress = snapshotData['start_address'] as String?;
    _endAddress = snapshotData['end_address'] as String?;
    _arretCoordonnee = snapshotData['arret_coordonnee'] as String?;
    _driverPhoto = snapshotData['driver_photo'] as String?;
    _riderPhoto = snapshotData['rider_photo'] as String?;
    _otherRiderData = snapshotData['other_rider_data'] as String?;
    _riderFirstname = snapshotData['rider_firstname'] as String?;
    _riderLastname = snapshotData['rider_lastname'] as String?;
    _riderContact = snapshotData['rider_contact'] as String?;
    _date = snapshotData['date'] as String?;
    _heure = snapshotData['heure'] as String?;
    _dateheure = snapshotData['dateheure'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('reservations');

  static Stream<ReservationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ReservationsRecord.fromSnapshot(s));

  static Future<ReservationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ReservationsRecord.fromSnapshot(s));

  static ReservationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ReservationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ReservationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ReservationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ReservationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ReservationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createReservationsRecordData({
  String? status,
  String? driverLastname,
  String? driverContact,
  String? driverImmatriculation,
  String? driverMarque,
  String? driverColor,
  String? serviceName,
  int? id,
  double? distance,
  int? montant,
  int? duration,
  double? endLatitude,
  double? endLongitude,
  double? startLatitude,
  double? startLongitude,
  int? driverId,
  int? riderId,
  String? driverName,
  int? serviceId,
  String? startAddress,
  String? endAddress,
  String? arretCoordonnee,
  String? driverPhoto,
  String? riderPhoto,
  String? otherRiderData,
  String? riderFirstname,
  String? riderLastname,
  String? riderContact,
  String? date,
  String? heure,
  DateTime? dateheure,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'status': status,
      'driver_lastname': driverLastname,
      'driver_contact': driverContact,
      'driver_immatriculation': driverImmatriculation,
      'driver_marque': driverMarque,
      'driver_color': driverColor,
      'service_name': serviceName,
      'id': id,
      'distance': distance,
      'montant': montant,
      'duration': duration,
      'end_latitude': endLatitude,
      'end_longitude': endLongitude,
      'start_latitude': startLatitude,
      'start_longitude': startLongitude,
      'driver_id': driverId,
      'rider_id': riderId,
      'driver_name': driverName,
      'service_id': serviceId,
      'start_address': startAddress,
      'end_address': endAddress,
      'arret_coordonnee': arretCoordonnee,
      'driver_photo': driverPhoto,
      'rider_photo': riderPhoto,
      'other_rider_data': otherRiderData,
      'rider_firstname': riderFirstname,
      'rider_lastname': riderLastname,
      'rider_contact': riderContact,
      'date': date,
      'heure': heure,
      'dateheure': dateheure,
    }.withoutNulls,
  );

  return firestoreData;
}

class ReservationsRecordDocumentEquality
    implements Equality<ReservationsRecord> {
  const ReservationsRecordDocumentEquality();

  @override
  bool equals(ReservationsRecord? e1, ReservationsRecord? e2) {
    return e1?.status == e2?.status &&
        e1?.driverLastname == e2?.driverLastname &&
        e1?.driverContact == e2?.driverContact &&
        e1?.driverImmatriculation == e2?.driverImmatriculation &&
        e1?.driverMarque == e2?.driverMarque &&
        e1?.driverColor == e2?.driverColor &&
        e1?.serviceName == e2?.serviceName &&
        e1?.id == e2?.id &&
        e1?.distance == e2?.distance &&
        e1?.montant == e2?.montant &&
        e1?.duration == e2?.duration &&
        e1?.endLatitude == e2?.endLatitude &&
        e1?.endLongitude == e2?.endLongitude &&
        e1?.startLatitude == e2?.startLatitude &&
        e1?.startLongitude == e2?.startLongitude &&
        e1?.driverId == e2?.driverId &&
        e1?.riderId == e2?.riderId &&
        e1?.driverName == e2?.driverName &&
        e1?.serviceId == e2?.serviceId &&
        e1?.startAddress == e2?.startAddress &&
        e1?.endAddress == e2?.endAddress &&
        e1?.arretCoordonnee == e2?.arretCoordonnee &&
        e1?.driverPhoto == e2?.driverPhoto &&
        e1?.riderPhoto == e2?.riderPhoto &&
        e1?.otherRiderData == e2?.otherRiderData &&
        e1?.riderFirstname == e2?.riderFirstname &&
        e1?.riderLastname == e2?.riderLastname &&
        e1?.riderContact == e2?.riderContact &&
        e1?.date == e2?.date &&
        e1?.heure == e2?.heure &&
        e1?.dateheure == e2?.dateheure;
  }

  @override
  int hash(ReservationsRecord? e) => const ListEquality().hash([
        e?.status,
        e?.driverLastname,
        e?.driverContact,
        e?.driverImmatriculation,
        e?.driverMarque,
        e?.driverColor,
        e?.serviceName,
        e?.id,
        e?.distance,
        e?.montant,
        e?.duration,
        e?.endLatitude,
        e?.endLongitude,
        e?.startLatitude,
        e?.startLongitude,
        e?.driverId,
        e?.riderId,
        e?.driverName,
        e?.serviceId,
        e?.startAddress,
        e?.endAddress,
        e?.arretCoordonnee,
        e?.driverPhoto,
        e?.riderPhoto,
        e?.otherRiderData,
        e?.riderFirstname,
        e?.riderLastname,
        e?.riderContact,
        e?.date,
        e?.heure,
        e?.dateheure
      ]);

  @override
  bool isValidKey(Object? o) => o is ReservationsRecord;
}

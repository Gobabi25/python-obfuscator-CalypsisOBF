import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "contact_number" field.
  String? _contactNumber;
  String get contactNumber => _contactNumber ?? '';
  bool hasContactNumber() => _contactNumber != null;

  // "driver_color" field.
  String? _driverColor;
  String get driverColor => _driverColor ?? '';
  bool hasDriverColor() => _driverColor != null;

  // "first_name" field.
  String? _firstName;
  String get firstName => _firstName ?? '';
  bool hasFirstName() => _firstName != null;

  // "last_name" field.
  String? _lastName;
  String get lastName => _lastName ?? '';
  bool hasLastName() => _lastName != null;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  bool hasId() => _id != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "id_request" field.
  int? _idRequest;
  int get idRequest => _idRequest ?? 0;
  bool hasIdRequest() => _idRequest != null;

  // "longitude" field.
  String? _longitude;
  String get longitude => _longitude ?? '';
  bool hasLongitude() => _longitude != null;

  // "latitude" field.
  String? _latitude;
  String get latitude => _latitude ?? '';
  bool hasLatitude() => _latitude != null;

  void _initializeFields() {
    _contactNumber = snapshotData['contact_number'] as String?;
    _firstName = snapshotData['first_name'] as String?;
    _lastName = snapshotData['last_name'] as String?;
    _id = castToType<int>(snapshotData['id']);
    _uid = snapshotData['uid'] as String?;
    _idRequest = castToType<int>(snapshotData['id_request']);
    _longitude = snapshotData['longitude'] as String?;
    _latitude = snapshotData['latitude'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? contactNumber,
  String? firstName,
  String? lastName,
  int? id,
  String? uid,
  int? idRequest,
  String? longitude,
  String? latitude,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'contact_number': contactNumber,
      'first_name': firstName,
      'last_name': lastName,
      'id': id,
      'uid': uid,
      'id_request': idRequest,
      'longitude': longitude,
      'latitude': latitude,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    return e1?.contactNumber == e2?.contactNumber &&
        e1?.firstName == e2?.firstName &&
        e1?.lastName == e2?.lastName &&
        e1?.id == e2?.id &&
        e1?.uid == e2?.uid &&
        e1?.idRequest == e2?.idRequest &&
        e1?.longitude == e2?.longitude &&
        e1?.latitude == e2?.latitude;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.contactNumber,
        e?.firstName,
        e?.lastName,
        e?.id,
        e?.uid,
        e?.idRequest,
        e?.longitude,
        e?.latitude
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}

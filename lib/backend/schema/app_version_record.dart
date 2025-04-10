import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AppVersionRecord extends FirestoreRecord {
  AppVersionRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "version" field.
  String? _version;
  String get version => _version ?? '';
  bool hasVersion() => _version != null;

  // "versionDriver" field.
  String? _versionDriver;
  String get versionDriver => _versionDriver ?? '';
  bool hasVersionDriver() => _versionDriver != null;

  void _initializeFields() {
    _version = snapshotData['version'] as String?;
    _versionDriver = snapshotData['versionDriver'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('app_version');

  static Stream<AppVersionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AppVersionRecord.fromSnapshot(s));

  static Future<AppVersionRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AppVersionRecord.fromSnapshot(s));

  static AppVersionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AppVersionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AppVersionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AppVersionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AppVersionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AppVersionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAppVersionRecordData({
  String? version,
  String? versionDriver,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'version': version,
      'versionDriver': versionDriver,
    }.withoutNulls,
  );

  return firestoreData;
}

class AppVersionRecordDocumentEquality implements Equality<AppVersionRecord> {
  const AppVersionRecordDocumentEquality();

  @override
  bool equals(AppVersionRecord? e1, AppVersionRecord? e2) {
    return e1?.version == e2?.version && e1?.versionDriver == e2?.versionDriver;
  }

  @override
  int hash(AppVersionRecord? e) =>
      const ListEquality().hash([e?.version, e?.versionDriver]);

  @override
  bool isValidKey(Object? o) => o is AppVersionRecord;
}

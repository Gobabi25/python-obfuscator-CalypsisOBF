import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ImgCarRecord extends FirestoreRecord {
  ImgCarRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "couleur" field.
  String? _couleur;
  String get couleur => _couleur ?? '';
  bool hasCouleur() => _couleur != null;

  void _initializeFields() {
    _image = snapshotData['image'] as String?;
    _name = snapshotData['name'] as String?;
    _couleur = snapshotData['couleur'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('imgCar');

  static Stream<ImgCarRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ImgCarRecord.fromSnapshot(s));

  static Future<ImgCarRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ImgCarRecord.fromSnapshot(s));

  static ImgCarRecord fromSnapshot(DocumentSnapshot snapshot) => ImgCarRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ImgCarRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ImgCarRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ImgCarRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ImgCarRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createImgCarRecordData({
  String? image,
  String? name,
  String? couleur,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'image': image,
      'name': name,
      'couleur': couleur,
    }.withoutNulls,
  );

  return firestoreData;
}

class ImgCarRecordDocumentEquality implements Equality<ImgCarRecord> {
  const ImgCarRecordDocumentEquality();

  @override
  bool equals(ImgCarRecord? e1, ImgCarRecord? e2) {
    return e1?.image == e2?.image &&
        e1?.name == e2?.name &&
        e1?.couleur == e2?.couleur;
  }

  @override
  int hash(ImgCarRecord? e) =>
      const ListEquality().hash([e?.image, e?.name, e?.couleur]);

  @override
  bool isValidKey(Object? o) => o is ImgCarRecord;
}

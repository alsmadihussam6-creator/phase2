import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phase_2_project/models/cvprojectmodel.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateCV(String uid, CVProjectModel cv) async {
    await _db.collection('cvs').doc(uid).set(cv.toMap());
  }

  Stream<CVProjectModel?> streamCV(String uid) {
    return _db.collection('cvs').doc(uid).snapshots().map((snap) {
      if (snap.exists && snap.data() != null) {
        return CVProjectModel.fromMap(snap.data()!, snap.id);
      }
      return null;
    });
  }
}
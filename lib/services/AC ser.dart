import 'package:cloud_firestore/cloud_firestore.dart';

class TechnicianServices {
  Stream<QuerySnapshot> getTechniciansStream(String categoryName) {
    return FirebaseFirestore.instance
        .collection(categoryName)
        .snapshots();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesServices {
  Stream<QuerySnapshot> getCategoriesStream() {
    return FirebaseFirestore.instance
        .collection('service_categories')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/AC ser.dart';

class TechnicianRepository {
  final TechnicianServices _services = TechnicianServices();

  Stream<QuerySnapshot> getTechnicians(String categoryName) {
    return _services.getTechniciansStream(categoryName);
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repository/AC rep.dart';

class AcViewModel extends ChangeNotifier {
  final TechnicianRepository _repository = TechnicianRepository();

  Stream<QuerySnapshot> getTechniciansStream(String categoryName) {
    return _repository.getTechnicians(categoryName);
  }
}
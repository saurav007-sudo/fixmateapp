import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repository/categories rep.dart';

class CategoriesViewModel extends ChangeNotifier {
  final CategoriesRepository _repository = CategoriesRepository();

  Stream<QuerySnapshot> getCategoriesStream() {
    return _repository.getCategories();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/categories ser.dart';

class CategoriesRepository {
  final CategoriesServices _services = CategoriesServices();

  Stream<QuerySnapshot> getCategories() {
    return _services.getCategoriesStream();
  }
}
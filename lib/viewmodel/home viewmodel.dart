import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repository/home rep.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();

  final TextEditingController searchController = TextEditingController();
  List<dynamic> availableCategories = [];
  List<dynamic> filteredCategories = [];
  bool isDialogShowing = false;

  void setIsDialogShowing(bool value) {
    isDialogShowing = value;
    notifyListeners();
  }

  void filterCategory(String query) {
    filteredCategories = availableCategories.where((doc) {
      var data = doc.data() as Map<String, dynamic>?;
      if (data == null) return false;

      String name = (data['name'] ?? data['ProductName'] ?? "").toLowerCase();
      String category = (data['selectedCategory'] ?? data['category'] ?? data['serviceCategory'] ?? "").toLowerCase();

      String q = query.toLowerCase();
      return name.contains(q) || category.contains(q);
    }).toList();
    notifyListeners();
  }

  void updateCategories(List<QueryDocumentSnapshot> docs) {
    availableCategories = docs;
    if (searchController.text.isEmpty) {
      filteredCategories = docs;
    }
  }

  Stream<QuerySnapshot> getVerifiedPartnersStream() {
    return _repository.getVerifiedPartners();
  }

  Stream<QuerySnapshot> getPendingBookingsStream(String userId) {
    return _repository.getPendingBookings(userId);
  }

  Future<void> updateTechnicianArrival(String docId, String status) async {
    await _repository.updateArrival(docId, status);
    isDialogShowing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
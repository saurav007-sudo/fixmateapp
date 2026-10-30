import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../repository/bookdetails rep.dart';

class BookingDetailsViewModel extends ChangeNotifier {
  final BookingDetailsRepository _repository = BookingDetailsRepository();
  bool isCancelling = false;

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';

  Stream<QuerySnapshot> getBookingStream(String? bookingId) {
    return _repository.getBooking(bookingId, userId);
  }

  Stream<DocumentSnapshot> getPartnerStream(String? partnerId) {
    return _repository.getPartner(partnerId);
  }

  Stream<QuerySnapshot> getAddressStream() {
    return _repository.getAddress(userId);
  }

  Future<bool> cancelBooking(String docId) async {
    isCancelling = true;
    notifyListeners();

    bool success = await _repository.cancelBooking(docId);

    isCancelling = false;
    notifyListeners();
    return success;
  }
}
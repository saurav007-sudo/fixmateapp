import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../repository/cancelled rep.dart';

class CancelledViewModel extends ChangeNotifier {
  final CancelledRepository _repository = CancelledRepository();

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';

  Stream<QuerySnapshot> getCancelledBookingsStream() {
    return _repository.getCancelledBookings(userId);
  }

  Stream<DocumentSnapshot> getPartnerStream(String? partnerId) {
    return _repository.getPartner(partnerId);
  }

  Stream<DocumentSnapshot> getLiveBookingStream(String docId) {
    return _repository.getLiveBooking(docId);
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/home ser.dart';

class HomeRepository {
  final HomeServices _services = HomeServices();

  Stream<QuerySnapshot> getVerifiedPartners() {
    return _services.getVerifiedPartnersStream();
  }

  Stream<QuerySnapshot> getPendingBookings(String userId) {
    return _services.getPendingBookingsStream(userId);
  }

  Future<void> updateArrival(String docId, String status) async {
    await _services.updateTechnicianArrivalInFirestore(docId, status);
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/cancelled ser.dart';

class CancelledRepository {
  final CancelledServices _services = CancelledServices();

  Stream<QuerySnapshot> getCancelledBookings(String userId) {
    return _services.getCancelledBookingsStream(userId);
  }

  Stream<DocumentSnapshot> getPartner(String? partnerId) {
    return _services.getPartnerStream(partnerId);
  }

  Stream<DocumentSnapshot> getLiveBooking(String docId) {
    return _services.getLiveBookingStream(docId);
  }
}
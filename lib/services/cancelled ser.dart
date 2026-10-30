import 'package:cloud_firestore/cloud_firestore.dart';

class CancelledServices {
  Stream<QuerySnapshot> getCancelledBookingsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'cancelled')
        .snapshots();
  }

  Stream<DocumentSnapshot> getPartnerStream(String? partnerId) {
    if (partnerId != null && partnerId.isNotEmpty) {
      return FirebaseFirestore.instance.collection('partners').doc(partnerId).snapshots();
    }
    return Stream.empty();
  }

  Stream<DocumentSnapshot> getLiveBookingStream(String docId) {
    return FirebaseFirestore.instance.collection('bookings').doc(docId).snapshots();
  }
}
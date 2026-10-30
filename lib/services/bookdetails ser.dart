import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDetailsServices {
  Stream<QuerySnapshot> getBookingStream(String? bookingId, String userId) {
    if (bookingId != null) {
      return FirebaseFirestore.instance
          .collection('bookings')
          .where(FieldPath.documentId, isEqualTo: bookingId)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: ['upcoming', 'pending'])
          .limit(1)
          .snapshots();
    }
  }

  Stream<DocumentSnapshot> getPartnerStream(String? partnerId) {
    if (partnerId != null && partnerId.isNotEmpty) {
      return FirebaseFirestore.instance.collection('partners').doc(partnerId).snapshots();
    }
    return const Stream.empty();
  }

  Stream<QuerySnapshot> getAddressStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .limit(1)
        .snapshots();
  }

  Future<bool> cancelBookingInFirestore(String docId) async {
    try {
      if (docId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(docId)
            .update({'status': 'cancelled'});
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
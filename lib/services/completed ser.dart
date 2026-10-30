import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedServices {
  Stream<QuerySnapshot> getCompletedBookingsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'completed')
        .snapshots();
  }
}
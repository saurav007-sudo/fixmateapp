import 'package:cloud_firestore/cloud_firestore.dart';

class HomeServices {
  Stream<QuerySnapshot> getVerifiedPartnersStream() {
    return FirebaseFirestore.instance
        .collection('partners')
        .where('isVerified', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPendingBookingsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  Future<void> updateTechnicianArrivalInFirestore(String docId, String status) async {
    await FirebaseFirestore.instance.collection('bookings').doc(docId).update({
      'technicianReached': status,
      if (status == 'confirmed') 'startTime': FieldValue.serverTimestamp(),
    });
    await FirebaseFirestore.instance.collection('jobs').doc(docId).update({
      'technicianReached': status,
      if (status == 'confirmed') 'startTime': FieldValue.serverTimestamp(),
    });
  }
}
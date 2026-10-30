import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfessionalServices {
  Stream<DocumentSnapshot> getPartnerStream(String? partnerId) {
    String docId = partnerId ??
        FirebaseAuth.instance.currentUser?.uid ??
        'sample_partner';

    return FirebaseFirestore.instance.collection('partners').doc(docId).snapshots();
  }
}
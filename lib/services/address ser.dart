import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressListServices {
  String get userId => FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';

  Stream<QuerySnapshot> getAddressesStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .snapshots();
  }

  Future<void> deleteAddressFromFirestore(String addressId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }
}
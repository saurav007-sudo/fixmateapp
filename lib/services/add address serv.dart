import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/add address model.dart';

class AddressServices {
  Future<void> saveAddressToFirestore(AddressModel addressModel) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .add(addressModel.toMap(FieldValue.serverTimestamp()));

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'address': addressModel.fullAddress,
    }, SetOptions(merge: true));
  }
}
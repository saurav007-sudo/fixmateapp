import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/editaddress models.dart';

class EditAddressServices {
  Future<DocumentSnapshot> fetchAddressDoc(String userId, String addressId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId)
        .get();
  }

  Future<void> updateAddressInFirestore(String userId, String addressId, EditAddressModel addressModel) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId)
        .update(addressModel.toMap(FieldValue.serverTimestamp()));
  }
}
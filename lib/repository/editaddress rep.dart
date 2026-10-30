import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/editaddress models.dart';
import '../services/editaddress ser.dart';


class EditAddressRepository {
  final EditAddressServices _services = EditAddressServices();

  Future<EditAddressModel?> getAddress(String userId, String addressId) async {
    var doc = await _services.fetchAddressDoc(userId, addressId);
    if (doc.exists && doc.data() != null) {
      return EditAddressModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateAddress(String userId, String addressId, EditAddressModel addressModel) async {
    await _services.updateAddressInFirestore(userId, addressId, addressModel);
  }
}
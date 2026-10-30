import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repository/address re.dart';

class AddressListViewmodel extends ChangeNotifier {
  final AddressListRepository _repository = AddressListRepository();

  Stream<QuerySnapshot> getAddressesStream() {
    return _repository.getAddresses();
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await _repository.deleteAddress(addressId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting address: $e");
    }
  }
}
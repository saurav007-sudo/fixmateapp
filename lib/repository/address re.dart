import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/address ser.dart';

class AddressListRepository {
  final AddressListServices _services = AddressListServices();

  Stream<QuerySnapshot> getAddresses() {
    return _services.getAddressesStream();
  }

  Future<void> deleteAddress(String addressId) async {
    await _services.deleteAddressFromFirestore(addressId);
  }
}
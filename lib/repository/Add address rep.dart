

import '../models/add address model.dart';
import '../services/add address serv.dart';

class AddressRepository {
  final AddressServices _services = AddressServices();

  Future<void> saveAddress(AddressModel addressModel) async {
    await _services.saveAddressToFirestore(addressModel);
  }
}
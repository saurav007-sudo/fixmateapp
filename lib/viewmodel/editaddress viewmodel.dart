import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/editaddress models.dart';
import '../repository/editaddress rep.dart';


class EditAddressViewModel extends ChangeNotifier {
  final EditAddressRepository _repository = EditAddressRepository();

  final TextEditingController houseController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  bool isLoading = false;

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';

  Future<void> loadAddressData(String? addressId) async {
    if (addressId == null) return;

    isLoading = true;
    notifyListeners();

    try {
      EditAddressModel? address = await _repository.getAddress(userId, addressId);
      if (address != null) {
        houseController.text = address.house;
        streetController.text = address.street;
        areaController.text = address.area;
        cityController.text = address.city;
        pincodeController.text = address.pincode;
      }
    } catch (e) {
      debugPrint("Error loading address: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> saveAddress(String? addressId) async {
    if (addressId == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      String fullAddress = "${houseController.text.trim()} ${areaController.text.trim()}, ${cityController.text.trim()}";

      EditAddressModel addressModel = EditAddressModel(
        house: houseController.text.trim(),
        street: streetController.text.trim(),
        area: areaController.text.trim(),
        city: cityController.text.trim(),
        pincode: pincodeController.text.trim(),
        fullAddress: fullAddress,
      );

      await _repository.updateAddress(userId, addressId, addressModel);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Failed to update address: $e");
      return false;
    }
  }

  @override
  void dispose() {
    houseController.dispose();
    streetController.dispose();
    areaController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    super.dispose();
  }
}
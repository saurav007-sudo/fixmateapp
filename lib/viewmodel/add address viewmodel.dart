import 'package:flutter/material.dart';

import '../models/add address model.dart';
import '../repository/Add address rep.dart';


class AddAddressViewmodel extends ChangeNotifier {
  final AddressRepository _repository = AddressRepository();

  final TextEditingController houseController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  bool isLoading = false;

  Future<void> saveAddress(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      String fullAddress = "${houseController.text.trim()} ${areaController.text.trim()}, ${cityController.text.trim()}";

      AddressModel addressModel = AddressModel(
        house: houseController.text.trim(),
        street: streetController.text.trim(),
        area: areaController.text.trim(),
        city: cityController.text.trim(),
        pincode: pincodeController.text.trim(),
        fullAddress: fullAddress,
      );

      await _repository.saveAddress(addressModel);

      isLoading = false;
      notifyListeners();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address added successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      isLoading = false;
      notifyListeners();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add address: $e")),
      );
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
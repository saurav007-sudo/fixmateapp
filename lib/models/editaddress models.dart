class EditAddressModel {
  final String house;
  final String street;
  final String area;
  final String city;
  final String pincode;
  final String fullAddress;

  EditAddressModel({
    required this.house,
    required this.street,
    required this.area,
    required this.city,
    required this.pincode,
    required this.fullAddress,
  });

  factory EditAddressModel.fromMap(Map<String, dynamic> map) {
    return EditAddressModel(
      house: map['house'] ?? '',
      street: map['street'] ?? '',
      area: map['area'] ?? '',
      city: map['city'] ?? '',
      pincode: map['pincode'] ?? '',
      fullAddress: map['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap(Object? serverTimestamp) {
    return {
      'address': fullAddress,
      'house': house,
      'street': street,
      'area': area,
      'city': city,
      'pincode': pincode,
      'updatedAt': serverTimestamp,
    };
  }
}
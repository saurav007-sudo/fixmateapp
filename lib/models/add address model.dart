class AddressModel {
  final String house;
  final String street;
  final String area;
  final String city;
  final String pincode;
  final String fullAddress;

  AddressModel({
    required this.house,
    required this.street,
    required this.area,
    required this.city,
    required this.pincode,
    required this.fullAddress,
  });

  Map<String, dynamic> toMap(Object? serverTimestamp) {
    return {
      'address': fullAddress,
      'house': house,
      'street': street,
      'area': area,
      'city': city,
      'pincode': pincode,
      'createdAt': serverTimestamp,
    };
  }
}
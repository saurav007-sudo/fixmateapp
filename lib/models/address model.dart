class AddressListModel {
  final String id;
  final String house;
  final String fullAddress;

  AddressListModel({
    required this.id,
    required this.house,
    required this.fullAddress,
  });

  factory AddressListModel.fromMap(Map<String, dynamic> map, String docId) {
    return AddressListModel(
      id: docId,
      house: map['house'] ?? "Address",
      fullAddress: map['address'] ?? "",
    );
  }
}
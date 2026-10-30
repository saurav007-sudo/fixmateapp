class BookingDetailsModel {
  final String id;
  final String bookingId;
  final String date;
  final String rating;
  final String image;
  final String description;
  final String partnerId;
  final String serviceName;
  final String name;

  BookingDetailsModel({
    required this.id,
    required this.bookingId,
    required this.date,
    required this.rating,
    required this.image,
    required this.description,
    required this.partnerId,
    required this.serviceName,
    required this.name,
  });

  factory BookingDetailsModel.fromMap(Map<String, dynamic> map, String docId) {
    return BookingDetailsModel(
      id: docId,
      bookingId: map['bookingId'] ?? '#${docId.substring(0, 6).toUpperCase()}',
      date: map['date'] ?? "25 Sep 2025 - 10:00 AM",
      rating: map['rating'] ?? "4.9",
      image: map['image'] ?? "lib/asset/44-extractpics.jpg",
      description: map['description'] ?? "The power sockets are not working",
      partnerId: map['partnerId'] ?? '',
      serviceName: map['serviceName'] ?? "AC Service",
      name: map['name'] ?? "Suresh",
    );
  }
}

class PartnerModel {
  final String name;
  final String category;
  final double basePrice;

  PartnerModel({
    required this.name,
    required this.category,
    required this.basePrice,
  });

  factory PartnerModel.fromMap(Map<String, dynamic> map) {
    double price = 299.0;
    var rawPrice = map['basePrice'] ?? map['price'] ?? map['servicePrice'];
    if (rawPrice != null) {
      String cleanedPrice = rawPrice.toString().replaceAll(RegExp(r'[^\d]'), '');
      price = double.tryParse(cleanedPrice) ?? 299.0;
    }

    return PartnerModel(
      name: map['name'] ?? "Suresh",
      category: map['category'] ?? map['serviceName'] ?? "AC Service",
      basePrice: price,
    );
  }
}

class AddressModel {
  final String displayAddress;

  AddressModel({required this.displayAddress});

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    String house = map['house'] ?? '';
    String fullAddress = map['address'] ?? '';
    String result = "Kadavanthra, Kochi";

    if (house.isNotEmpty && fullAddress.isNotEmpty) {
      result = "$house\n$fullAddress";
    } else {
      result = fullAddress.isNotEmpty ? fullAddress : (house.isNotEmpty ? house : result);
    }

    return AddressModel(displayAddress: result);
  }
}
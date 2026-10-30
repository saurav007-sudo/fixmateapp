class CancelledBookingModel {
  final String id;
  final String partnerId;
  final String professionalName;
  final String serviceName;
  final String rating;
  final String distance;
  final String imagePath;
  final String price;

  CancelledBookingModel({
    required this.id,
    required this.partnerId,
    required this.professionalName,
    required this.serviceName,
    required this.rating,
    required this.distance,
    required this.imagePath,
    required this.price,
  });

  factory CancelledBookingModel.fromMaps(
      Map<String, dynamic> bookingData,
      Map<String, dynamic>? partnerData,
      Map<String, dynamic>? liveBookingData,
      String docId,
      ) {
    String professionalName = partnerData?['name'] ??
        partnerData?['partnerName'] ??
        partnerData?['fullName'] ??
        bookingData['name'] ??
        "Suresh";

    String serviceName = bookingData['serviceName'] ?? "AC Service";
    String rating = bookingData['rating']?.toString() ?? "4.5";
    String distance = bookingData['distance']?.toString() ?? "2.2 KM";
    String imagePath = bookingData['image']?.toString() ?? "lib/asset/44-extractpics.jpg";

    String priceStr = liveBookingData?['basePrice']?.toString() ??
        liveBookingData?['price']?.toString() ??
        bookingData['basePrice'] ??
        bookingData['price'] ??
        '0';

    return CancelledBookingModel(
      id: docId,
      partnerId: bookingData['partnerId'] ?? '',
      professionalName: professionalName,
      serviceName: serviceName,
      rating: rating,
      distance: distance,
      imagePath: imagePath,
      price: priceStr,
    );
  }
}
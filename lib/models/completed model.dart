class CompletedBookingModel {
  final String serviceName;
  final String technicianName;
  final double totalAmount;
  final String imagePath;
  final String rating;
  final String location;

  CompletedBookingModel({
    required this.serviceName,
    required this.technicianName,
    required this.totalAmount,
    required this.imagePath,
    required this.rating,
    required this.location,
  });

  factory CompletedBookingModel.fromMap(Map<String, dynamic> map) {
    String serviceName = map['serviceName'] ?? 'Service';
    String technicianName = map['name'] ?? 'Technician';
    double basePrice = double.tryParse(map['basePrice']?.toString() ?? '299') ?? 299.0;
    double serviceFee = basePrice * 0.05;
    double platformFee = 25.0;
    double totalAmount = basePrice + serviceFee + platformFee;

    String imagePath = map['image'] ?? "lib/asset/44-extractpics.jpg";
    String rating = map['rating'] ?? "4.9";
    String location = map['location'] ?? "Kochi";

    return CompletedBookingModel(
      serviceName: serviceName,
      technicianName: technicianName,
      totalAmount: totalAmount,
      imagePath: imagePath,
      rating: rating,
      location: location,
    );
  }
}
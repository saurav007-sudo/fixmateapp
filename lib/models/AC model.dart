class TechnicianModel {
  final String id;
  final String name;
  final String experience;
  final String price;
  final String rating;
  final String distance;
  final String image;

  TechnicianModel({
    required this.id,
    required this.name,
    required this.experience,
    required this.price,
    required this.rating,
    required this.distance,
    required this.image,
  });

  factory TechnicianModel.fromMap(Map<String, dynamic> map, String docId) {
    // Check all possible Firestore image fields
    var rawImage = map['profileImage'] ??
        map['imageUrl'] ??
        map['image'] ??
        map['profileUrl'] ??
        map['professionalImage'] ??
        map['photo'] ??
        map['avatar'] ??
        map['img'];

    // Convert to string and trim
    String imageStr = rawImage?.toString().trim() ?? '';

    // If the string is empty or just whitespace, use the local asset fallback
    String resolvedImage = imageStr.isNotEmpty
        ? imageStr
        : "assets/44-extractpics.jpg";

    return TechnicianModel(
      id: docId,
      name: map['name'] ?? map['fullName'] ?? "Technician",
      experience: map['yearsOfExperience']?.toString() ?? map['exp'] ?? "3+ years",
      price: map['basePrice']?.toString() ?? map['price'] ?? "599",
      rating: map['rating']?.toString() ?? "4.9 (98)",
      distance: map['distance'] ?? "2.2 Km",
      image: resolvedImage,
    );
  }
}
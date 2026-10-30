class ProfessionalModel {
  final String name;
  final String primaryCategory;
  final String dynamicServiceName;
  final String basePrice;
  final String descriptionText;
  final String experienceYears;

  ProfessionalModel({
    required this.name,
    required this.primaryCategory,
    required this.dynamicServiceName,
    required this.basePrice,
    required this.descriptionText,
    required this.experienceYears,
  });

  factory ProfessionalModel.fromMap(Map<String, dynamic>? data) {
    String name = data?['name'] ??
        data?['partnerName'] ??
        data?['fullName'] ??
        data?['username'] ??
        "Suresh Babu";

    String primaryCategory = data?['serviceCategory'] ??
        data?['selectedCategory'] ??
        data?['category'] ??
        "AC Technician";

    String dynamicServiceName = data?['serviceName'] ??
        data?['selectedCategory'] ??
        data?['serviceCategory'] ??
        "Electrical";

    String basePrice = data?['basePrice']?.toString() ??
        data?['price']?.toString() ??
        data?['servicePrice']?.toString() ??
        data?['rate']?.toString() ??
        "299";

    String descriptionText = data?['serviceDescription'] ??
        data?['workDescription'] ??
        data?['description'] ??
        data?['bio'] ??
        data?['details'] ??
        "Repair switches, sockets and electrical faults";

    String rawExp = data?['yearsOfExperience']?.toString() ??
        data?['experience']?.toString() ??
        data?['exp']?.toString() ??
        "3";

    String experienceYears = rawExp.toLowerCase().contains('year')
        ? rawExp
        : "$rawExp Years";

    return ProfessionalModel(
      name: name,
      primaryCategory: primaryCategory,
      dynamicServiceName: dynamicServiceName,
      basePrice: basePrice,
      descriptionText: descriptionText,
      experienceYears: experienceYears,
    );
  }
}
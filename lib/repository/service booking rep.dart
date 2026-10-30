import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/service booking ser.dart';

class ProfessionalRepository {
  final ProfessionalServices _services = ProfessionalServices();

  Stream<DocumentSnapshot> getPartner(String? partnerId) {
    return _services.getPartnerStream(partnerId);
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/completed ser.dart';

class CompletedRepository {
  final CompletedServices _services = CompletedServices();

  Stream<QuerySnapshot> getCompletedBookings(String userId) {
    return _services.getCompletedBookingsStream(userId);
  }
}
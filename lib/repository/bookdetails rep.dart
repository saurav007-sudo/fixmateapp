import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/bookdetails ser.dart';

class BookingDetailsRepository {
  final BookingDetailsServices _services = BookingDetailsServices();

  Stream<QuerySnapshot> getBooking(String? bookingId, String userId) {
    return _services.getBookingStream(bookingId, userId);
  }

  Stream<DocumentSnapshot> getPartner(String? partnerId) {
    return _services.getPartnerStream(partnerId);
  }

  Stream<QuerySnapshot> getAddress(String userId) {
    return _services.getAddressStream(userId);
  }

  Future<bool> cancelBooking(String docId) async {
    return await _services.cancelBookingInFirestore(docId);
  }
}
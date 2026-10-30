
import '../models/booking confirmed model.dart';

class ConfirmServices {
  ConfirmModel formatConfirmationData(
      DateTime? selectedDate,
      String? selectedTime,
      String? technicianName,
      String? customBookingId,
      ) {
    return ConfirmModel(
      selectedDate: selectedDate,
      selectedTime: selectedTime,
      technicianName: technicianName,
      customBookingId: customBookingId,
    );
  }
}
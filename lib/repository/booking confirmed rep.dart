
import '../models/booking confirmed model.dart';
import '../services/booking confirmed ser.dart';

class ConfirmRepository {
  final ConfirmServices _services = ConfirmServices();

  ConfirmModel processConfirmation(
      DateTime? selectedDate,
      String? selectedTime,
      String? technicianName,
      String? customBookingId,
      ) {
    return _services.formatConfirmationData(
      selectedDate,
      selectedTime,
      technicianName,
      customBookingId,
    );
  }
}
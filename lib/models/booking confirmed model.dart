import 'package:intl/intl.dart';

class ConfirmModel {
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? technicianName;
  final String? customBookingId;

  ConfirmModel({
    this.selectedDate,
    this.selectedTime,
    this.technicianName,
    this.customBookingId,
  });

  String get formattedDate => selectedDate != null
      ? DateFormat('d MMMM yyyy').format(selectedDate!)
      : "15 October";

  String get timeText => selectedTime ?? "10:00 AM";

  String get technician => technicianName ?? "Technician";

  String get bookingIdDisplay => customBookingId ?? "FX001";
}
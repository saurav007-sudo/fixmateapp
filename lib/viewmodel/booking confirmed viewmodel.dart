import 'package:flutter/material.dart';

import '../models/booking confirmed model.dart';
import '../repository/booking confirmed rep.dart';

class ConfirmViewModel extends ChangeNotifier {
  final ConfirmRepository _repository = ConfirmRepository();

  ConfirmModel getConfirmationData(
      DateTime? selectedDate,
      String? selectedTime,
      String? technicianName,
      String? customBookingId,
      ) {
    return _repository.processConfirmation(
      selectedDate,
      selectedTime,
      technicianName,
      customBookingId,
    );
  }
}
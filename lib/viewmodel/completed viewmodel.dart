import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../repository/completed rep.dart';

class CompletedViewModel extends ChangeNotifier {
  final CompletedRepository _repository = CompletedRepository();

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';

  Stream<QuerySnapshot> getCompletedBookingsStream() {
    return _repository.getCompletedBookings(userId);
  }
}
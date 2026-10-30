// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../repository/upcoming rep.dart';
//
// class UpcomingViewModel extends ChangeNotifier {
//   final UpcomingRepository _repository = UpcomingRepository();
//
//   String get userId => FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';
//
//   Stream<QuerySnapshot> getUpcomingBookingsStream() {
//     return _repository.getUpcomingBookings(userId);
//   }
// }
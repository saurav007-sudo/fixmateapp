import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../repository/service booking rep.dart';

class ProfessionalViewModel extends ChangeNotifier {
  final ProfessionalRepository _repository = ProfessionalRepository();

  final List<IconData> boxIcons = [
    CupertinoIcons.calendar,
    CupertinoIcons.tag_fill,
    CupertinoIcons.alarm,
  ];

  Stream<DocumentSnapshot> getPartnerStream(String? partnerId) {
    return _repository.getPartner(partnerId);
  }
}
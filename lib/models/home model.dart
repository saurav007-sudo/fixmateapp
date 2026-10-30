import 'package:flutter/material.dart';

class HomeModel {
  final List<String> priceList = [
    "From ₹299",
    "From ₹299",
    "From ₹299",
  ];

  final List<String> imgList = [
    "lib/asset/Ac repair.jpg",
    "lib/asset/plumb png.png",
    "lib/asset/electrician.png",
  ];

  final List<String> popularServices = [
    "AC Service",
    "Plumbing",
    "Electrical Repair",
  ];

  final List<IconData> badgeIcons = [
    Icons.verified_user,
    Icons.flash_on,
    Icons.credit_card,
    Icons.headset_mic,
  ];

  final List<String> badgeTexts = [
    "Verified",
    "Quick",
    "Secure",
    "24/7",
  ];
}
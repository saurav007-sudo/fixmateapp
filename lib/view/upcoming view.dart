import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view/bookdetails view.dart';

class Upcomings extends StatefulWidget {
  Upcomings({super.key});

  @override
  State<Upcomings> createState() => _UpcomingsState();
}

class _UpcomingsState extends State<Upcomings> {
  String get userId => FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';

  Stream<QuerySnapshot> getUpcomingBookingsStream() {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: ['upcoming', 'pending'])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FAFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 40, bottom: 10),
            child: Text(
              "My Bookings",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getUpcomingBookingsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No upcoming bookings found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                var docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var bookingData = docs[index].data() as Map<String, dynamic>? ?? {};
                    String docId = docs[index].id;

                    String professionalName = bookingData['name'] ?? "Suresh Babu";
                    String serviceName = bookingData['serviceName'] ?? "AC Service";

                    double displayPrice = 299.0;
                    var rawPrice = bookingData['basePrice'] ?? bookingData['price'];

                    if (rawPrice != null) {
                      String cleanedPrice = rawPrice.toString().replaceAll(RegExp(r'[^\d]'), '');
                      displayPrice = double.tryParse(cleanedPrice) ?? 299.0;
                    }

                    String rating = bookingData['rating']?.toString() ?? "4.9";
                    String distance = bookingData['distance']?.toString() ?? "2.2 KM";

                    String? profileImageUrl = bookingData['profileImage'] ??
                        bookingData['image'] ??
                        bookingData['imageUrl'] ??
                        bookingData['partnerImage'];

                    ImageProvider avatarImageProvider;
                    if (profileImageUrl != null && profileImageUrl.startsWith('http')) {
                      avatarImageProvider = NetworkImage(profileImageUrl);
                    } else {
                      avatarImageProvider = AssetImage("lib/asset/44-extractpics.jpg");
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Details(bookingId: docId),
                            ),
                          );
                        },
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, bottom: 15),
                                child: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  backgroundImage: avatarImageProvider,
                                  radius: 38,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        serviceName,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        professionalName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: CupertinoColors.activeBlue,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.star_fill,
                                            color: Colors.yellow,
                                            size: 15,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            rating,
                                            style: TextStyle(fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          Text(distance),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15.0, bottom: 58.0),
                                child: Text(
                                  "₹${displayPrice.toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.blue,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
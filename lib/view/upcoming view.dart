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

  // Helper method to fetch basePrice from partners collection
  Future<double> _fetchPartnerBasePrice(String? partnerId, double fallbackPrice) async {
    if (partnerId == null || partnerId.isEmpty) return fallbackPrice;
    try {
      // Check 'partners' collection first
      var doc = await FirebaseFirestore.instance.collection('partners').doc(partnerId).get();
      if (doc.exists && doc.data()?['basePrice'] != null) {
        return double.tryParse(doc.data()!['basePrice'].toString()) ?? fallbackPrice;
      }

      // Fallback check 'partner' collection (singular)
      var docSingular = await FirebaseFirestore.instance.collection('partner').doc(partnerId).get();
      if (docSingular.exists && docSingular.data()?['basePrice'] != null) {
        return double.tryParse(docSingular.data()!['basePrice'].toString()) ?? fallbackPrice;
      }
    } catch (e) {
      debugPrint("Error fetching partner base price: $e");
    }
    return fallbackPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FAFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
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
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
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
                    String? partnerId = bookingData['partnerId'];

                    double initialPrice = 299.0;
                    var rawPrice = bookingData['basePrice'] ?? bookingData['price'];

                    if (rawPrice != null) {
                      String cleanedPrice = rawPrice.toString().replaceAll(RegExp(r'[^\d]'), '');
                      initialPrice = double.tryParse(cleanedPrice) ?? 299.0;
                    }

                    String? profileImageUrl = bookingData['profileImage'] ??
                        bookingData['image'] ??
                        bookingData['imageUrl'] ??
                        bookingData['partnerImage'];

                    ImageProvider avatarImageProvider;
                    if (profileImageUrl != null && profileImageUrl.startsWith('http')) {
                      avatarImageProvider = NetworkImage(profileImageUrl);
                    } else {
                      avatarImageProvider = const AssetImage("lib/asset/44-extractpics.jpg");
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                                padding: const EdgeInsets.only(left: 10, bottom: 15),
                                child: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  backgroundImage: avatarImageProvider,
                                  radius: 38,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15, bottom: 22),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        serviceName,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        professionalName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: CupertinoColors.activeBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Fetch and display basePrice from partners collection dynamically
                              FutureBuilder<double>(
                                future: _fetchPartnerBasePrice(partnerId, initialPrice),
                                builder: (context, priceSnapshot) {
                                  double displayPrice = priceSnapshot.data ?? initialPrice;

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15.0, bottom: 58.0),
                                    child: Text(
                                      "₹${displayPrice.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                  );
                                },
                              ),
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
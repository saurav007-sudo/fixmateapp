import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/completed model.dart';
import '../viewmodel/completed viewmodel.dart';

class Completed extends StatefulWidget {
  const Completed({super.key});

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompletedViewModel>(
      builder: (context, completedViewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF3FAFF),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 50, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Completed Bookings",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: completedViewModel.getCompletedBookingsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No completed bookings found.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    var docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var bookingData = docs[index].data() as Map<String, dynamic>? ?? {};
                        CompletedBookingModel completedBooking = CompletedBookingModel.fromMap(bookingData);

                        // 1. Extract profile image URL from booking document (checks profileImage, image, imageUrl, partnerImage)
                        String? profileImageUrl = bookingData['profileImage'] ??
                            bookingData['image'] ??
                            bookingData['imageUrl'] ??
                            bookingData['partnerImage'];

                        // 2. Select NetworkImage if it's a valid URL, otherwise fallback to AssetImage
                        ImageProvider avatarImageProvider;
                        if (profileImageUrl != null && profileImageUrl.startsWith('http')) {
                          avatarImageProvider = NetworkImage(profileImageUrl);
                        } else {
                          avatarImageProvider = AssetImage(completedBooking.imagePath);
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.blue.shade200),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.green,
                                    backgroundImage: avatarImageProvider, // Dynamically loaded database or asset image
                                    radius: 36,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          completedBooking.serviceName,
                                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          completedBooking.technicianName,
                                          style: const TextStyle(fontSize: 15, color: CupertinoColors.activeBlue, fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(CupertinoIcons.star_fill, color: Colors.yellow, size: 14),
                                            const SizedBox(width: 4),
                                            Text(completedBooking.rating, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                                            const SizedBox(width: 10),
                                            const Icon(Icons.location_on, color: Colors.red, size: 14),
                                            const SizedBox(width: 2),
                                            Expanded(
                                              child: Text(
                                                completedBooking.location,
                                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "₹${completedBooking.totalAmount.toStringAsFixed(0)}",
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.blue),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDDF8F0),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "Completed",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
      },
    );
  }
}
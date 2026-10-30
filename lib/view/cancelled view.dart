import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cancelled model.dart';
import '../viewmodel/cancelled viewmodel.dart';

class Cancelled extends StatefulWidget {
  const Cancelled({super.key});

  @override
  State<Cancelled> createState() => _CancelledState();
}

class _CancelledState extends State<Cancelled> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CancelledViewModel>(
      builder: (context, cancelledViewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF3FAFF),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: EdgeInsets.only(left: 20, top: 40, bottom: 10),
                child: Text(
                  "Cancelled Bookings",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: cancelledViewModel.getCancelledBookingsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No cancelled bookings yet.",
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
                        String? partnerId = bookingData['partnerId'];

                        return StreamBuilder<DocumentSnapshot>(
                          stream: cancelledViewModel.getPartnerStream(partnerId),
                          builder: (context, partnerSnapshot) {
                            var partnerData = partnerSnapshot.data?.data() as Map<String, dynamic>?;

                            return StreamBuilder<DocumentSnapshot>(
                              stream: cancelledViewModel.getLiveBookingStream(docId),
                              builder: (context, bookingSnapshot) {
                                var liveBookingData = bookingSnapshot.data?.data() as Map<String, dynamic>?;

                                CancelledBookingModel cancelledBooking = CancelledBookingModel.fromMaps(
                                  bookingData,
                                  partnerData,
                                  liveBookingData,
                                  docId,
                                );

                                // 1. Extract profile image URL from partnerData, liveBookingData, or bookingData (Supabase/Firestore URL)
                                String? profileImageUrl = partnerData?['profileImage'] ??
                                    partnerData?['image'] ??
                                    partnerData?['imageUrl'] ??
                                    liveBookingData?['profileImage'] ??
                                    liveBookingData?['image'] ??
                                    bookingData['profileImage'] ??
                                    bookingData['image'];

                                // 2. Select NetworkImage if valid HTTP URL exists, otherwise fallback to AssetImage
                                ImageProvider avatarImageProvider;
                                if (profileImageUrl != null && profileImageUrl.startsWith('http')) {
                                  avatarImageProvider = NetworkImage(profileImageUrl);
                                } else {
                                  avatarImageProvider = AssetImage(cancelledBooking.imagePath);
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.red.shade200),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, bottom: 15),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            backgroundImage: avatarImageProvider, // Dynamically loaded database image or fallback
                                            radius: 38,
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
                                                  cancelledBooking.serviceName,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  cancelledBooking.professionalName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: CupertinoColors.activeBlue,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      CupertinoIcons.star_fill,
                                                      color: Colors.yellow,
                                                      size: 15,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      cancelledBooking.rating,
                                                      style: const TextStyle(fontWeight: FontWeight.w800),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    const Icon(
                                                      Icons.location_on,
                                                      color: Colors.red,
                                                      size: 16,
                                                    ),
                                                    Text(cancelledBooking.distance),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0, bottom: 58.0),
                                          child: Text(
                                            "₹${cancelledBooking.price}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
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
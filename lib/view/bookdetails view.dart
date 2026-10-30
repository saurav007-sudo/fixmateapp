import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher for phone dialpad

import '../models/bookdetails model.dart';
import '../viewmodel/bookdetails viewmodel.dart';
import 'booknow view.dart';
import 'cancelled view.dart';

class Details extends StatefulWidget {
  final String? bookingId;

  const Details({super.key, this.bookingId});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not launch dialpad")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  void _confirmAndCancelBooking(BuildContext context, String docId) {
    final viewModel = Provider.of<BookingDetailsViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Cancel Booking"),
        content: const Text("Are you sure you want to cancel this booking?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              bool success = await viewModel.cancelBooking(docId);

              if (!mounted) return;

              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Cancelled()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to cancel booking")),
                );
              }
            },
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingDetailsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.blue[50],
          body: viewModel.isCancelling
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<QuerySnapshot>(
            stream: viewModel.getBookingStream(widget.bookingId),
            builder: (context, bookingSnapshot) {
              if (bookingSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!bookingSnapshot.hasData || bookingSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "Booking details not found.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              var bookingDoc = bookingSnapshot.data!.docs.first;
              var bookingData = bookingDoc.data() as Map<String, dynamic>;
              BookingDetailsModel booking = BookingDetailsModel.fromMap(bookingData, bookingDoc.id);

              return StreamBuilder<DocumentSnapshot>(
                stream: viewModel.getPartnerStream(booking.partnerId),
                builder: (context, partnerSnapshot) {
                  double servicePrice = 299.0;
                  String professionalName = booking.name;
                  String serviceCategory = booking.serviceName;
                  String professionalPhone = '';
                  String? partnerProfileImage;

                  if (partnerSnapshot.hasData && partnerSnapshot.data != null && partnerSnapshot.data!.exists) {
                    var partnerData = partnerSnapshot.data!.data() as Map<String, dynamic>?;
                    if (partnerData != null) {
                      PartnerModel partner = PartnerModel.fromMap(partnerData);
                      professionalName = partner.name;
                      serviceCategory = partner.category;
                      servicePrice = partner.basePrice;

                      professionalPhone = partnerData['phoneno'] ??
                          partnerData['phone'] ??
                          partnerData['phoneNumber'] ?? '';

                      partnerProfileImage = partnerData['profileImage'] ??
                          partnerData['imageUrl'] ??
                          partnerData['image'] ??
                          partnerData['professionalImage'];
                    }
                  }

                  ImageProvider avatarImageProvider;
                  if (partnerProfileImage != null && partnerProfileImage.startsWith('http')) {
                    avatarImageProvider = NetworkImage(partnerProfileImage);
                  } else if (booking.image.isNotEmpty && booking.image.startsWith('http')) {
                    avatarImageProvider = NetworkImage(booking.image);
                  } else {
                    avatarImageProvider = AssetImage(booking.image.isNotEmpty ? booking.image : "lib/image/logo.png");
                  }

                  double serviceFee = servicePrice * 0.05;
                  double platformFee = 25.0;
                  double totalAmount = servicePrice + serviceFee + platformFee;

                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(CupertinoIcons.arrow_left),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 18),
                              child: Text(
                                "Booking Details",
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 48,
                                      backgroundColor: Colors.blue.shade50,
                                      backgroundImage: avatarImageProvider,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            serviceCategory,
                                            style: const TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            professionalName,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                          ),
                                          if (professionalPhone.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            GestureDetector(
                                              onTap: () => _makePhoneCall(professionalPhone),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.phone, size: 14, color: Colors.green),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    professionalPhone,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 7),
                                          Row(
                                            children: [
                                              Icon(
                                                CupertinoIcons.star_fill,
                                                color: Colors.amber[700],
                                                size: 20,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(booking.rating,
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                              const SizedBox(width: 10),
                                              const Text("(322)",
                                                  style: TextStyle(fontSize: 16, color: Colors.grey)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: Container(height: 1, color: Colors.grey[300]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                                child: Row(
                                  children: [
                                    const Text("Date & Time", style: TextStyle(fontSize: 17)),
                                    const Spacer(),
                                    Text(booking.date, style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: viewModel.getAddressStream(),
                                builder: (context, addressSnapshot) {
                                  String displayAddress = "Kadavanthra, Kochi";

                                  if (addressSnapshot.hasData && addressSnapshot.data!.docs.isNotEmpty) {
                                    var addressData = addressSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                                    AddressModel addressModel = AddressModel.fromMap(addressData);
                                    displayAddress = addressModel.displayAddress;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 22),
                                    child: Row(
                                      children: [
                                        const Text("Address", style: TextStyle(fontSize: 17)),
                                        const Spacer(),
                                        Expanded(
                                          child: Text(
                                            displayAddress,
                                            style: const TextStyle(fontSize: 15),
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 22),
                                child: Row(
                                  children: [
                                    const Text("Booking ID",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                    const Spacer(),
                                    Text(booking.bookingId,
                                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue.shade200, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Problem Description",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '"${booking.description}"',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 15, top: 18),
                                child: Text(
                                  "Price Breakdown",
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                                child: Row(
                                  children: [
                                    const Text("Service Price", style: TextStyle(fontSize: 17)),
                                    const Spacer(),
                                    Text("₹${servicePrice.toStringAsFixed(0)}", style: const TextStyle(fontSize: 17)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 16),
                                child: Row(
                                  children: [
                                    const Text("Service Fee (5%)", style: TextStyle(fontSize: 17)),
                                    const Spacer(),
                                    Text("₹${serviceFee.toStringAsFixed(0)}", style: const TextStyle(fontSize: 17)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 16),
                                child: Row(
                                  children: [
                                    const Text("Platform Fee", style: TextStyle(fontSize: 17)),
                                    const Spacer(),
                                    Text("₹${platformFee.toStringAsFixed(0)}", style: const TextStyle(fontSize: 17)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 14),
                                child: Container(height: 1, color: Colors.grey[300]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 14),
                                child: Row(
                                  children: [
                                    const Text("Total Amount",
                                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                                    const Spacer(),
                                    Text("₹${totalAmount.toStringAsFixed(0)}",
                                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 15),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _confirmAndCancelBooking(context, booking.id),
                              child: Container(
                                height: 58,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.red[800]!, width: 1.5),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel Booking ID",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red[800],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Booknow()),
                                    );
                                  },
                                  child: Container(
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Reschedule",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 2),
                                          child: Icon(
                                            CupertinoIcons.arrow_right,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
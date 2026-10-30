import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../view/booking confirmed view.dart';

class Booknow extends StatefulWidget {
  final String? partnerId;

  const Booknow({super.key, this.partnerId});

  @override
  State<Booknow> createState() => _BooknowState();
}

class _BooknowState extends State<Booknow> {
  DateTime today = DateTime.now();
  int? selectedTimeIndex;
  bool isLoading = false;

  final TextEditingController problemController = TextEditingController();

  final List<String> timeSlots = [
    "09:00 AM",
    "10:00 AM",
    "12:00 PM",
    "02:00 PM",
    "04:00 PM",
    "06:00 PM",
  ];

  void selectDay(DateTime day, DateTime focusDay) {
    setState(() {
      today = day;
    });
  }

  void selectTime(int index) {
    setState(() {
      selectedTimeIndex = index;
    });
  }

  Future<String> _generateBookingId() async {
    try {
      var counterDoc = await FirebaseFirestore.instance.collection('counters').doc('booking_counter').get();
      int currentCounter = 1;

      if (counterDoc.exists) {
        currentCounter = (counterDoc.data()?['count'] ?? 0) + 1;
      }

      await FirebaseFirestore.instance.collection('counters').doc('booking_counter').set({'count': currentCounter});

      return 'FX${currentCounter.toString().padLeft(3, '0')}';
    } catch (_) {
      int randomNum = 100 + DateTime.now().millisecondsSinceEpoch % 900;
      return 'FX$randomNum';
    }
  }

  Stream<QuerySnapshot> getAddressStream() {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .limit(1)
        .snapshots();
  }

  Future<void> createBookingInFirestore(BuildContext context, String fetchedAddress) async {
    if (selectedTimeIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a time slot")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';
      String formattedDate = DateFormat('d MMMM yyyy').format(today);
      String chosenTime = timeSlots[selectedTimeIndex!];
      String problemText = problemController.text.trim();
      String customBookingId = await _generateBookingId();

      String technicianName = '';
      String basePrice = '299';
      String serviceName = 'General Service';
      String targetPartnerId = widget.partnerId ?? '';
      String partnerProfileImage = 'lib/asset/44-extractpics.jpg';

      if (widget.partnerId != null && widget.partnerId!.isNotEmpty) {
        DocumentSnapshot partnerDoc = await FirebaseFirestore.instance
            .collection('partners')
            .doc(widget.partnerId)
            .get();

        if (partnerDoc.exists) {
          var partnerData = partnerDoc.data() as Map<String, dynamic>?;
          technicianName = partnerData?['name'] ?? '';
          basePrice = partnerData?['basePrice']?.toString() ?? partnerData?['price']?.toString() ?? '299';
          serviceName = partnerData?['serviceName'] ?? partnerData?['category'] ?? 'General Service';
          partnerProfileImage = partnerData?['profileImage'] ?? partnerData?['imageUrl'] ?? partnerProfileImage;
        }
      } else {
        QuerySnapshot partnerQuery = await FirebaseFirestore.instance
            .collection('partners')
            .limit(1)
            .get();

        if (partnerQuery.docs.isNotEmpty) {
          var partnerDoc = partnerQuery.docs.first;
          targetPartnerId = partnerDoc.id;
          var partnerData = partnerDoc.data() as Map<String, dynamic>;
          technicianName = partnerData['name'] ?? '';
          basePrice = partnerData['basePrice']?.toString() ?? partnerData['price']?.toString() ?? '299';
          serviceName = partnerData['serviceName'] ?? partnerData['category'] ?? 'General Service';
          partnerProfileImage = partnerData['profileImage'] ?? partnerData['imageUrl'] ?? partnerProfileImage;
        }
      }

      if (serviceName.isNotEmpty && targetPartnerId.isNotEmpty) {
        try {
          DocumentSnapshot categoryDoc = await FirebaseFirestore.instance
              .collection(serviceName)
              .doc(targetPartnerId)
              .get();

          if (categoryDoc.exists) {
            var catData = categoryDoc.data() as Map<String, dynamic>?;
            if (catData != null) {
              serviceName = catData['serviceName'] ?? catData['category'] ?? serviceName;
              basePrice = catData['basePrice']?.toString() ?? catData['price']?.toString() ?? basePrice;
            }
          }
        } catch (_) {}
      }

      Map<String, dynamic> bookingData = {
        'bookingId': customBookingId,
        'userId': userId,
        'partnerId': targetPartnerId,
        'serviceName': serviceName,
        'customerName': 'Saurav K',
        'name': technicianName,
        'basePrice': basePrice,
        'description': problemText.isNotEmpty ? problemText : 'No description provided',
        'image': partnerProfileImage,
        'profileImage': partnerProfileImage,
        'rating': '4.9 (98)',
        'location': fetchedAddress,
        'date': formattedDate,
        'time': chosenTime,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      DocumentReference jobRef = await FirebaseFirestore.instance.collection('jobs').add(bookingData);
      await FirebaseFirestore.instance.collection('bookings').doc(jobRef.id).set(bookingData);

      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Confirm(
            selectedDate: today,
            selectedTime: chosenTime,
            technicianName: technicianName,
            customBookingId: customBookingId,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save booking: $e")),
      );
    }
  }

  @override
  void dispose() {
    problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FAFF),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(CupertinoIcons.arrow_left),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 10,
                ),
                child: Text(
                  "Book Your Service",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              top: 24,
            ),
            child: Text(
              "Select Date",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Colors.blue[900],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              focusedDay: today,
              firstDay: DateTime.utc(2003, 1, 1),
              lastDay: DateTime.utc(2026, 12, 31),
              onDaySelected: selectDay,
              selectedDayPredicate: (day) => isSameDay(day, today),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                ),
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              bottom: 10,
            ),
            child: Text(
              "Select Time",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Colors.blue[900],
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 25,
                mainAxisExtent: 40,
              ),
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedTimeIndex == index;
                return GestureDetector(
                  onTap: () {
                    selectTime(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 8),
                    child: Container(
                      height: 25,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Center(
                        child: Text(
                          timeSlots[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              top: 25,
            ),
            child: Text(
              "Describe Problem",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Colors.blue[900],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
            ),
            child: TextField(
              controller: problemController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Type your problem here...",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.blueGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              top: 25,
            ),
            child: Text(
              "Service Address",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Colors.blue[900],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: getAddressStream(),
            builder: (context, addressSnapshot) {
              String displayAddress = "Select address";

              if (addressSnapshot.hasData && addressSnapshot.data!.docs.isNotEmpty) {
                var addressData = addressSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                String house = addressData['house'] ?? '';
                String fullAddress = addressData['address'] ?? '';

                if (house.isNotEmpty && fullAddress.isNotEmpty) {
                  displayAddress = "$house\n$fullAddress";
                } else {
                  displayAddress = fullAddress.isNotEmpty ? fullAddress : house;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 10,
                ),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.blueGrey,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: CircleAvatar(
                          radius: 23,
                          backgroundColor: Color(0xFFE6F2FF),
                          child: Icon(
                            CupertinoIcons.location_fill,
                            color: Colors.blue,
                            size: 23,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Text(
                            displayAddress,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(
                          CupertinoIcons.chevron_right,
                          color: Colors.blue,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 25,
              bottom: 20,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: getAddressStream(),
              builder: (context, addressSnapshot) {
                String fetchedAddress = "";
                if (addressSnapshot.hasData && addressSnapshot.data!.docs.isNotEmpty) {
                  var addressData = addressSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                  String house = addressData['house'] ?? '';
                  String fullAddress = addressData['address'] ?? '';
                  fetchedAddress = fullAddress.isNotEmpty ? fullAddress : house;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Confirm()));
                    createBookingInFirestore(context, fetchedAddress);
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            CupertinoIcons.arrow_right,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
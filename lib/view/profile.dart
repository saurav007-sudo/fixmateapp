import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmate/view/Mybookings.dart';
import 'package:fixmate/view/Personal%20info.dart';
import 'package:fixmate/view/privacy%20rules.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'address view.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final List<IconData> accountIcons = [
    CupertinoIcons.person_fill,
    CupertinoIcons.location_fill,
  ];

  final List<String> accountTitle = [
    "Personal Information",
    "My Addresses",
  ];

  final List<String> accountSubtitle = [
    "Name, phone, email",
    "Home, Work, Others",
  ];

  final List<Color> accountColors = [
    Color(0xFFE1F0FF),
    Color(0xFFDDF8F0),
  ];

  Future<void> _logout(BuildContext context) async {
    try {
      bool? confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Color(0xFFEFF9FF),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: userId.isNotEmpty
              ? FirebaseFirestore.instance.collection('users').doc(userId).snapshots()
              : null,
          builder: (context, snapshot) {
            String userName = currentUser?.displayName ?? "Saurav K";
            String profileImagePath = "lib/asset/44-extractpics.jpg";

            if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
              var userData = snapshot.data!.data() as Map<String, dynamic>?;
              userName = userData?['name'] ?? userData?['fullName'] ?? userName;
              profileImagePath = userData?['profileImage'] ?? profileImagePath;
            }

            ImageProvider avatarImage = profileImagePath.startsWith('http')
                ? NetworkImage(profileImagePath) as ImageProvider
                : AssetImage(profileImagePath);

            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "FIXMATE",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25, color: Colors.blue),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        backgroundImage: avatarImage,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.blue[900],
                              ),
                            ),
                            Text(
                              "User",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Mybookings()));
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          )
                        ],
                        color: Color(0xFFE8F4FF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 18.0),
                            child: CircleAvatar(
                              radius: 27,
                              backgroundColor: Color(0xFFD8ECFF),
                              child: Icon(
                                CupertinoIcons.briefcase_fill,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "My Bookings",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "View your past bookings",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "My Account",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: Colors.blue[900],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                              child: GestureDetector(
                                onTap: () {
                                  if (index == 0) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Personal()));
                                  } else if (index == 1) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPage()));
                                  }
                                },
                                child: Container(
                                  height: 65,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 13.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 22,
                                          backgroundColor: accountColors[index],
                                          child: Icon(
                                            accountIcons[index],
                                            color: Colors.blue,
                                            size: 24,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 18),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                accountTitle[index],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.blue[900],
                                                ),
                                              ),
                                              Text(
                                                accountSubtitle[index],
                                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () => _logout(context),
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Color(0xFFEAF4FF),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 25),
                            child: Icon(CupertinoIcons.square_arrow_right, color: Colors.red),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "Logout",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
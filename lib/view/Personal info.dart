// lib/Screen/Personal info.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmate/view/editpersonal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Personal extends StatefulWidget {
  Personal({super.key});

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String userId = currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Color(0xFFEFF9FF),
      body: SafeArea(
        child: userId.isEmpty
            ? Center(child: Text("No user logged in"))
            : StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            Map<String, dynamic> userData = {};
            if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
              userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
            }

            String name = userData['name'] ?? userData['fullName'] ?? currentUser?.displayName ?? "Saurav K";
            String email = userData['email'] ?? currentUser?.email ?? "ksaurath@gmail.com";
            String phone = userData['phone'] ?? userData['phoneNumber'] ?? currentUser?.phoneNumber ?? "+91 6282716279";
            String dob = userData['dob'] ?? "08/12/2003";
            String imagePath = userData['profileImage'] ?? "lib/asset/44-extractpics.jpg";

            ImageProvider avatarImage = imagePath.startsWith('http')
                ? NetworkImage(imagePath) as ImageProvider
                : AssetImage(imagePath);

            return ListView(
              padding: EdgeInsets.only(bottom: 30),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          CupertinoIcons.arrow_left,
                          size: 28,
                          color: Colors.blue[900],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 22),
                        child: Text(
                          "Personal Information",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                initialName: name,
                                initialEmail: email,
                                initialPhone: phone,
                                initialDob: dob,
                                initialImagePath: imagePath,
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 23,
                          backgroundColor: Color(0xFFDCEEFF),
                          child: Icon(
                            CupertinoIcons.pencil,
                            color: Colors.blue[800],
                            size: 21,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: avatarImage,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                "Customer",
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(CupertinoIcons.person, "Full name", name),
                        _divider(),
                        _buildInfoRow(CupertinoIcons.mail, "Email address", email),
                        _divider(),
                        _buildInfoRow(CupertinoIcons.phone, "Phone number", phone),
                        _divider(),
                        _buildInfoRow(CupertinoIcons.calendar, "Date of Birth", dob),
                      ],
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

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: Color(0xFFE7F3FF),
            child: Icon(icon, color: Colors.blue[800], size: 25),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14)),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.only(left: 80, right: 15),
      child: Container(height: 1, color: Colors.grey[300]),
    );
  }
}
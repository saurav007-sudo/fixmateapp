import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmate/view/profile.dart';
import 'package:fixmate/view/service%20booking%20view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/home model.dart';
import '../viewmodel/home viewmodel.dart';
import 'AC view.dart';
import 'categories view.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeModel homeModel = HomeModel();

  void _showArrivalDialog(BuildContext context, HomeViewModel provider, String docId, String technicianName) {
    if (provider.isDialogShowing) return;
    provider.setIsDialogShowing(true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text("Technician Arrival"),
        content: Text("Has $technicianName reached your location?"),
        actions: [
          TextButton(
            onPressed: () async {
              await provider.updateTechnicianArrival(docId, 'not_reached');
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: Text("No", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              await provider.updateTechnicianArrival(docId, 'confirmed');
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: Text("Yes, they have", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: homeViewModel.getPendingBookingsStream(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    for (var doc in snapshot.data!.docs) {
                      var data = doc.data() as Map<String, dynamic>;
                      var reachedFlag = data['technicianReached'];

                      if (reachedFlag == 'waiting') {
                        String technicianName = data['name'] ?? 'The technician';
                        String docId = doc.id;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _showArrivalDialog(context, homeViewModel, docId, technicianName);
                        });
                      }
                    }
                  }
                  return SizedBox.shrink();
                },
              ),
              ListView(
                children: [
                  ListTile(
                    leading: Container(
                      height: 65,
                      width: 37,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/asset/logo2.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text("Fix", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25, color: Colors.black)),
                        Text("mate", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25, color: Colors.blue)),
                      ],
                    ),
                    trailing: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Icon(CupertinoIcons.profile_circled),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: (value) {
                        homeViewModel.filterCategory(value);
                      },
                      controller: homeViewModel.searchController,
                      cursorColor: Color(0xff7b0001),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Search Here (e.g. AC Service, Plumbing...)',
                        prefixIcon: Icon(Icons.search, color: Color(0xff7b0001)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xff7b0001),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xff7b0001),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/asset/image1_fixmat.png"),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategoriesPage()),
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 10, bottom: 8),
                          child: Text("Popular Services", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Text("See all", style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w800)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4, right: 15, top: 2),
                          child: Icon(CupertinoIcons.arrow_right, size: 12, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 133,
                    child: ListView.builder(
                      itemCount: homeModel.popularServices.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AC(categoryName: homeModel.popularServices[index]),
                              ),
                            );
                          },
                          child: Container(
                            height: 118,
                            width: 97,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: double.infinity,
                                  child: Image.asset(homeModel.imgList[index], fit: BoxFit.fill),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 72, left: 4, right: 4),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        homeModel.popularServices[index],
                                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        homeModel.priceList[index],
                                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Colors.blue),
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
                  Padding(
                    padding: EdgeInsets.only(left: 12, right: 14, top: 10),
                    child: SizedBox(
                      height: 45,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Container(
                            height: 40,
                            width: 86,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(homeModel.badgeIcons[index], size: 20, color: Colors.green),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text(homeModel.badgeTexts[index], style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 14),
                          child: Text("Nearby Professionals", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: homeViewModel.getVerifiedPartnersStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('Error :: ${snapshot.error}'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasData) {
                        homeViewModel.updateCategories(snapshot.data!.docs);

                        if (homeViewModel.filteredCategories.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text("No verified professionals nearby yet.", style: TextStyle(color: Colors.grey)),
                          );
                        }

                        return Column(
                          children: homeViewModel.filteredCategories.map((snap) {
                            var partner = snap.data() as Map<String, dynamic>;
                            String docId = snap.id;
                            String pName = partner['name'] ?? partner['ProductName'] ?? "Partner";
                            String pRole = partner['selectedCategory'] ?? partner['category'] ?? partner['serviceCategory'] ?? "Technician";

                            String? profileImageUrl = partner['profileImage'] ?? partner['imageUrl'];

                            ImageProvider avatarImage;
                            if (profileImageUrl != null && profileImageUrl.startsWith('http')) {
                              avatarImage = NetworkImage(profileImageUrl);
                            } else {
                              avatarImage = AssetImage("lib/asset/44-extractpics.jpg");
                            }

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Professional(partnerId: docId),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            backgroundImage: avatarImage,
                                            radius: 38,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text(
                                                  pName,
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 10, top: 2),
                                                child: Text(
                                                  pRole,
                                                  style: TextStyle(fontSize: 13, color: CupertinoColors.activeBlue),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 10, top: 4),
                                                child: Row(
                                                  children: [
                                                    Icon(CupertinoIcons.star_fill, color: Colors.yellow, size: 14),
                                                    SizedBox(width: 4),
                                                    Text("4.9", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                                                    SizedBox(width: 6),
                                                    Icon(Icons.location_on, color: Colors.red, size: 14),
                                                    Text("2.2 Km", style: TextStyle(fontSize: 12)),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
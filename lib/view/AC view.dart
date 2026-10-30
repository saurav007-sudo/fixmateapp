import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixmate/view/service%20booking%20view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/AC model.dart';
import '../viewmodel/AC viewmodel.dart';

class AC extends StatelessWidget {
  final String categoryName;

  AC({super.key, this.categoryName = "AC Service"});

  @override
  Widget build(BuildContext context) {
    return Consumer<AcViewModel>(
      builder: (context, acViewModel, child) {
        return Scaffold(
          backgroundColor: Color(0xFFF3FAFF),
          body: Column(
            children: [
              ListTile(
                leading: Text(
                  "FIXMATE",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
                    color: Colors.blue,
                  ),
                ),
                trailing: Icon(CupertinoIcons.profile_circled),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, top: 13, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    categoryName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 15, top: 13, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nearby Professionals",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: acViewModel.getTechniciansStream(categoryName),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "No $categoryName technicians available nearby.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    var docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var doc = docs[index];
                        var data = doc.data() as Map<String, dynamic>;

                        TechnicianModel technician = TechnicianModel.fromMap(data, doc.id);

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Professional(partnerId: technician.id),
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
                                      backgroundImage: AssetImage(technician.image),
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
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                technician.name,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(right: 15),
                                                child: Text(
                                                  "From ₹${technician.price}",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            technician.experience,
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
                                                technician.rating,
                                                style: TextStyle(fontWeight: FontWeight.w800),
                                              ),
                                              SizedBox(width: 12),
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.red,
                                                size: 16,
                                              ),
                                              SizedBox(width: 4),
                                              Text(technician.distance),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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
      },
    );
  }
}
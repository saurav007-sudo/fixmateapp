import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/address model.dart';
import '../viewmodel/address viewmodel.dart';
import 'add address view.dart';
import 'editaddress view.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddressListViewmodel>(
      builder: (context, addressViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child:  Icon(CupertinoIcons.back, color: Colors.blue),
              ),
            ),
            title:  Text(
              "My Addresses",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: addressViewModel.getAddressesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(
                          child: Text(
                            "No saved addresses found. Add one below!",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      );
                    }

                    var docs = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var doc = docs[index];
                        var addressData = doc.data() as Map<String, dynamic>;

                        AddressListModel address = AddressListModel.fromMap(addressData, doc.id);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset:  Offset(0, 4),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child:  Icon(
                                      CupertinoIcons.placemark_fill,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                   SizedBox(width: 12),
                                  Text(
                                    address.house,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                   Spacer(),
                                   Icon(
                                    CupertinoIcons.check_mark_circled_solid,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                ],
                              ),
                               SizedBox(height: 10),
                              Row(
                                children: [
                                   Icon(
                                    CupertinoIcons.location_solid,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                   SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      address.fullAddress,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditAddressPage(addressId: address.id),
                                        ),
                                      );
                                    },
                                    child:  Row(
                                      children: [
                                        Icon(CupertinoIcons.pen, color: Colors.blue, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          "Edit",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                   SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: () async {
                                      await addressViewModel.deleteAddress(address.id);
                                    },
                                    child:  Row(
                                      children: [
                                        Icon(CupertinoIcons.delete, color: Colors.blue, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                 SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  AddAddressPage()),
                    );
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:  Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: CircleAvatar(
                            backgroundColor: Color(0xFFE1F0FF),
                            radius: 18,
                            child: Icon(CupertinoIcons.add, color: Colors.blue, size: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            "Add New Address",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                 SizedBox(height: 20),
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child:  Center(
                    child: Text(
                      "Confirm Address",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
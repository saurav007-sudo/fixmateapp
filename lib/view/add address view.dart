import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/add address viewmodel.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AddAddressViewmodel>(
      builder: (context, addressProvider, child) {
        return Scaffold(
          backgroundColor: Colors.blue[50],
          appBar: AppBar(
            backgroundColor: Colors.blue[50],
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon:  Icon(CupertinoIcons.arrow_left, color: Colors.black),
            ),
            title:  Text(
              "Add New Address",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),
          body: addressProvider.isLoading
              ?  Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset:  Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          "Enter Address Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                         SizedBox(height: 20),
                        TextFormField(
                          controller: addressProvider.houseController,
                          decoration: InputDecoration(
                            labelText: "House / Building Name",
                            hintText: "e.g., Home or Skyline Apartments",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:  BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty ? "Please enter building name" : null,
                        ),
                         SizedBox(height: 15),
                        TextFormField(
                          controller: addressProvider.streetController,
                          decoration: InputDecoration(
                            labelText: "Street Name",
                            hintText: "e.g., Kadavanthra Road",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty ? "Please enter street name" : null,
                        ),
                         SizedBox(height: 15),
                        TextFormField(
                          controller: addressProvider.areaController,
                          decoration: InputDecoration(
                            labelText: "Area / Locality",
                            hintText: "e.g., Kadavanthra",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:  BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty ? "Please enter area" : null,
                        ),
                         SizedBox(height: 15),
                        TextFormField(
                          controller: addressProvider.cityController,
                          decoration: InputDecoration(
                            labelText: "City",
                            hintText: "e.g., Kochi",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:  BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty ? "Please enter city" : null,
                        ),
                         SizedBox(height: 15),
                        TextFormField(
                          controller: addressProvider.pincodeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Pincode",
                            hintText: "e.g., 682020",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:  BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                          validator: (value) => value == null || value.length < 6 ? "Please enter a valid pincode" : null,
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: 25),
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addressProvider.saveAddress(context);
                        }
                      },
                      child:  Text(
                        "Save Address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
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
  }
}
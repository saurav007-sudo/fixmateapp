import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/editaddress viewmodel.dart';

class EditAddressPage extends StatefulWidget {
  final String? addressId;

  const EditAddressPage({super.key, this.addressId});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EditAddressViewModel>(context, listen: false).loadAddressData(widget.addressId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditAddressViewModel>(
      builder: (context, editAddressViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.blue[50],
          appBar: AppBar(
            backgroundColor: Colors.blue[50],
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(CupertinoIcons.arrow_left, color: Colors.black),
            ),
            title: Text(
              "Edit Address",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),
          body: editAddressViewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivery / Service Location",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: editAddressViewModel.houseController,
                          decoration: InputDecoration(
                            labelText: "House / Building Name",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) => value == null || value.isEmpty ? "Please enter building name" : null,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: editAddressViewModel.streetController,
                          decoration: InputDecoration(
                            labelText: "Street Name",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) => value == null || value.isEmpty ? "Please enter street name" : null,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: editAddressViewModel.areaController,
                          decoration: InputDecoration(
                            labelText: "Area / Locality",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) => value == null || value.isEmpty ? "Please enter area" : null,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: editAddressViewModel.cityController,
                          decoration: InputDecoration(
                            labelText: "City",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) => value == null || value.isEmpty ? "Please enter city" : null,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: editAddressViewModel.pincodeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Pincode",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool success = await editAddressViewModel.saveAddress(widget.addressId);
                          if (!context.mounted) return;
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Address updated successfully!")),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to update address")),
                            );
                          }
                        }
                      },
                      child: Text(
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
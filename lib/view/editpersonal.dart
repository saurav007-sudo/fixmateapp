import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialDob;
  final String initialImagePath;

  EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialDob,
    required this.initialImagePath,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dobController;

  XFile? selectedImageFile;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    emailController = TextEditingController(text: widget.initialEmail);
    phoneController = TextEditingController(text: widget.initialPhone);
    dobController = TextEditingController(text: widget.initialDob);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImageFile = pickedFile;
      });
    }
  }

  Future<String?> _uploadImageToSupabase(XFile imageFile) async {
    try {
      final supabase = Supabase.instance.client;
      String timestamp = DateTime.now().microsecondsSinceEpoch.toString();
      String filePath = 'profile_images/$timestamp.jpg';

      if (kIsWeb) {
        Uint8List fileBytes = await imageFile.readAsBytes();
        await supabase.storage.from('fixmate').uploadBinary(
          filePath,
          fileBytes,
          fileOptions: FileOptions(cacheControl: '3600', upsert: true),
        );
      } else {
        File file = File(imageFile.path);
        await supabase.storage.from('fixmate').upload(
          filePath,
          file,
          fileOptions: FileOptions(cacheControl: '3600', upsert: true),
        );
      }

      return supabase.storage.from('fixmate').getPublicUrl(filePath);
    } catch (e) {
      debugPrint("Supabase upload error: $e");
      return null;
    }
  }

  Future<void> _saveProfile() async {
    setState(() => isSaving = true);

    try {
      String imageUrl = widget.initialImagePath;

      if (selectedImageFile != null) {
        String? uploadedUrl = await _uploadImageToSupabase(selectedImageFile!);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'dob': dobController.text.trim(),
          'profileImage': imageUrl,
        }, SetOptions(merge: true));
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully!"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF9FF),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(bottom: 30),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
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
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: selectedImageFile != null
                            ? (kIsWeb
                            ? NetworkImage(selectedImageFile!.path) as ImageProvider
                            : FileImage(File(selectedImageFile!.path)))
                            : (widget.initialImagePath.startsWith('http')
                            ? NetworkImage(widget.initialImagePath) as ImageProvider
                            : AssetImage(widget.initialImagePath) as ImageProvider),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue[800],
                          child: Icon(
                            CupertinoIcons.camera_fill,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Container(
                padding: EdgeInsets.all(20),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField("Full Name", CupertinoIcons.person, nameController),
                    SizedBox(height: 15),
                    _buildTextField("Email Address", CupertinoIcons.mail, emailController, keyboardType: TextInputType.emailAddress),
                    SizedBox(height: 15),
                    _buildTextField("Phone Number", CupertinoIcons.phone, phoneController, keyboardType: TextInputType.phone),
                    SizedBox(height: 15),
                    _buildTextField("Date of Birth", CupertinoIcons.calendar, dobController),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: GestureDetector(
                onTap: isSaving ? null : _saveProfile,
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: isSaving
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.blue[800], size: 22),
            filled: true,
            fillColor: Color(0xFFF7F9FC),
            contentPadding: EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
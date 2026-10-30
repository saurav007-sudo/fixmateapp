import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth viewmodel.dart';
import 'login.dart';

class Forgot extends StatefulWidget {
  Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final TextEditingController mail = TextEditingController();

  @override
  void dispose() {
    mail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(left: 18.0),
          child: Text("Forgot Password", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
        ),
      ),
      body: authViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 28, left: 10, right: 10),
            child: TextField(
              controller: mail,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue),
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Enter your email",
                labelStyle: TextStyle(fontWeight: FontWeight.w800),
                label: Text("Email"),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, right: 1),
            child: GestureDetector(
              onTap: () async {
                bool success = await authViewModel.sendPasswordReset(mail.text);
                if (!mounted) return;
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Reset link sent to your email ${mail.text}"), backgroundColor: Colors.green),
                  );
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Incorrect email or error sending reset link"), backgroundColor: Colors.red),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 47,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text("Continue", style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
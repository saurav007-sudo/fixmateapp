import 'package:fixmate/view/bottom.dart';
import 'package:fixmate/view/create.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide Create;

import '../viewmodel/auth viewmodel.dart';
import 'forgot.dart';
import 'home view.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController mail = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  void dispose() {
    mail.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: authViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 70),
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/asset/logo2.png"),
                    ),
                  ),
                ),
                Container(
                  height: 450,
                  width: 400,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.only(top: 40, left: 17, right: 20),
                    child: Column(
                      children: [
                        TextField(
                          controller: mail,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: "Enter your email address",
                            labelStyle: TextStyle(fontWeight: FontWeight.w800),
                            label: Text("Email address"),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextField(
                            controller: pass,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlue),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: "Enter your password",
                              labelStyle: TextStyle(fontWeight: FontWeight.w800),
                              label: Text("Password"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 155),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Forgot()));
                            },
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, right: 1),
                          child: GestureDetector(
                            onTap: () async {
                              bool success = await authViewModel.signIn(mail.text, pass.text);
                              if (!mounted) return;
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Login Successfully"), backgroundColor: Colors.green),
                                );
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bottom()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Login failed"), backgroundColor: Colors.red),
                                );
                              }
                            },
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
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text("------------------------ OR -----------------------", style: TextStyle(fontSize: 20)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, right: 1),
                          child: GestureDetector(
                            onTap: () async {
                              bool success = await authViewModel.signInWithGoogle();
                              if (!mounted) return;
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Login successful"), backgroundColor: Colors.green),
                                );
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Google Sign-In failed"), backgroundColor: Colors.red),
                                );
                              }
                            },
                            child: Container(
                              height: 47,
                              width: 400,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: Text("Continue with Google", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, right: 1),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Create()));
                            },
                            child: Container(
                              height: 47,
                              width: 400,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: Text("Create new account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
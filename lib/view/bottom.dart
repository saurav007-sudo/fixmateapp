import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixmate/view/Mybookings.dart';
import 'package:fixmate/view/profile.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'categories view.dart';
import 'home view.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int select = 0;

  final List page = [
    Home(),
    CategoriesPage(),
    Mybookings(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: select,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,

        onTap: (index) {
          setState(() {
            select = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),

          BottomNavigationBarItem(
            label: "Category",
            icon: Icon(Icons.category),
            activeIcon: Icon(Icons.category_outlined),
          ),

          BottomNavigationBarItem(
            label: "Bookings",
            icon: Icon(Icons.book_online),
            activeIcon: Icon(Icons.book_online),
          ),

          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
          ),
        ],
      ),
      body: page[select],
    );
  }
}
import 'package:fixmate/view/upcoming%20view.dart';
import 'package:flutter/material.dart';

import 'cancelled view.dart';
import 'completed view.dart';

class Mybookings extends StatefulWidget {
  Mybookings({super.key});

  @override
  State<Mybookings> createState() => _MybookingsState();
}

class _MybookingsState extends State<Mybookings> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: Colors.black87,
              indicatorColor: Colors.grey,
              indicatorWeight: 5,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.black87,
              dividerHeight: 5,
              tabs: [
                Tab(
                  text: "Upcoming",
                ),
                Tab(
                  text: "Completed",
                ),
                Tab(
                  text: "Cancelled",
                )
              ]),
        ),
        body: TabBarView(children: [
          Upcomings(),
          Completed(),
          Cancelled()
        ]),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/booking confirmed model.dart';
import '../viewmodel/booking confirmed viewmodel.dart';
import 'bookdetails view.dart';


class Confirm extends StatefulWidget {
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? technicianName;
  final String? customBookingId;

  const Confirm({
    super.key,
    this.selectedDate,
    this.selectedTime,
    this.technicianName,
    this.customBookingId,
  });

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ConfirmViewModel>(context);
    ConfirmModel confirmData = viewModel.getConfirmationData(
      widget.selectedDate,
      widget.selectedTime,
      widget.technicianName,
      widget.customBookingId,
    );

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 288.0, top: 40),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon:  Icon(Icons.arrow_left),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(
                CupertinoIcons.check_mark,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Text(
              "Booking Confirmed",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Booking ID : ${confirmData.bookingIdDisplay}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: Center(
              child: Text(
                "${confirmData.technician} will arrive ",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          Center(
            child: Text(
              "on ${confirmData.formattedDate} at ${confirmData.timeText}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 88.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Details()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: Text(
                      "View Booking details",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
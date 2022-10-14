import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rave_events/screens/Home/seats.dart';

// ignore: must_be_immutable
class BookingScreen extends StatefulWidget {
  Map<String, dynamic> eventData;
  BookingScreen({super.key, required this.eventData});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(context);
            },
            icon: const Icon(Ionicons.chevron_back),
            color: Colors.black,
          ),
          title: const Text('select a seat'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Wrap(
                  children: List.generate(
                      int.parse(widget.eventData['vipSlots']),
                      (index) => CustomSeat(
                          index: index, eventData: widget.eventData)),
                )
              ],
            ),
          ),
        ));
  }
}

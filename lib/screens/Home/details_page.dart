import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rave_events/screens/Home/pay_gate.dart';
import 'package:rave_events/screens/Home/saved_events.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'google_api_home.dart';

class Details extends StatefulWidget {
  Map<String, dynamic> eventData;
  Details({super.key, required this.eventData});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  void _showPaymentClarificationPanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          var event = widget.eventData;
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: PaymentClarity(
              eventData: event,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: size.height * 0.5,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.eventData['image']),
                    fit: BoxFit.cover)),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Ionicons.chevron_back),
                        color: Colors.black),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SavedEvents()));
                        },
                        icon: const Icon(Ionicons.bag_outline),
                        color: Colors.black)
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.45),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    child: Container(
                      width: 150,
                      height: 7,
                      decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.eventData['name'],
                    style: const TextStyle(
                        color: Colors.grey, height: 1.5, fontSize: 20),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy – kk:mm')
                        .format(widget.eventData['date'].toDate()),
                    style: const TextStyle(
                        color: Colors.grey, height: 1.5, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'VIP',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'UGX ${widget.eventData['vipPrice']}',
                          style: const TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ordinary',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'UGX ${widget.eventData['ordinaryPrice']}',
                          style: const TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.blueGrey,
                      elevation: 7.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ApiHome()));
                        },
                        child: const Center(
                          child: Text('Get Directions',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.blueGrey,
                      elevation: 7.0,
                      child: InkWell(
                        onTap: () {
                          _showPaymentClarificationPanel();
                        },
                        child: const Center(
                          child: Text('Make Payment',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

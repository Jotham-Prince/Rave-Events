import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class DisplayPaymentsInfo extends StatelessWidget {
  final paymentInfo;
  QRViewController controller;
  DisplayPaymentsInfo(
      {super.key, required this.paymentInfo, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Customer Info'),
        centerTitle: true,
        backgroundColor: Colors.grey,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              controller.resumeCamera();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(paymentInfo['profpic'] ??
                    'https://www.pngitem.com/pimgs/m/504-5040528_empty-profile-picture-png-transparent-png.png'),
              ),
            ),
            Divider(
              color: Colors.grey[800],
              height: 60.0,
            ),
            const Text(
              'NAME',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              paymentInfo['name'] ?? 'No name available',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'EVENT',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              paymentInfo['event'] ?? 'No event payed for',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'VIP STATUS',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              paymentInfo['vipStatus'] ?? 'Unknown',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

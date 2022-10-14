import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:rave_events/models/user_model.dart';
import 'dart:math';
import 'dart:io';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';

// ignore: must_be_immutable
class CustomSeat extends StatefulWidget {
  int index;
  Map<String, dynamic> eventData;
  CustomSeat({super.key, required this.index, required this.eventData});

  @override
  State<CustomSeat> createState() => _CustomSeatState();
}

class _CustomSeatState extends State<CustomSeat> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    String ref = '';
    bool availability = true;
    Color color = Colors.green;

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('UserData')
            .doc(user!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (availability) {
                    Random rand = Random();
                    int number = rand.nextInt(2000);

                    if (Platform.isAndroid) {
                      setState(() {
                        ref = "AndroidRef1789$number";
                      });
                    } else {
                      setState(() {
                        ref = "IOSRef1789$number";
                      });
                    }
                    final email = user.email;
                    final amount = widget.eventData['vipPrice'];
                    if (email!.isEmpty || amount.isEmpty) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Email or Amount Empty"),
                      ));
                    } else {
                      ///Flutter payements
                      // ignore: use_build_context_synchronously
                      ChargeResponse? response = await _makePayment(
                          context,
                          email.trim(),
                          amount.trim(),
                          ref,
                          snapshot.data!.data()!['name']);
                      if (response != null) {
                        if (response.data == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Transaction Failed"),
                          ));
                        } else {
                          if (response.status == "sucess") {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${response.data}"),
                            ));
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${response.message}"),
                            ));
                            setState(() {
                              availability = false;
                              color = Colors.red;
                            });
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${response.message}"),
                            ));
                            print(response.message);
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Transaction Failed"),
                        ));
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Seat already taken",
                        style: TextStyle(color: Colors.red),
                      ),
                    ));
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Text(
                      '${widget.index + 1}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: color,
                      border: Border.all(color: Colors.black)),
                ),
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(color: Colors.greenAccent));
          }
        });
  }
}

Future<ChargeResponse?> _makePayment(BuildContext context, String email,
    String amount, String ref, String name) async {
  try {
    Flutterwave flutterwave = Flutterwave.forUIPayment(
      context: context,
      fullName: name,
      phoneNumber: '123456789',
      email: email,
      amount: amount,
      encryptionKey: "FLWSECK_TEST0f3fac06ab1f",
      publicKey: "FLWPUBK_TEST-0135b35c626b09bd2f02dc1caac58233-X",
      currency: "UGX",
      txRef: ref,
      //Setting DebugMode below to true since will be using test mode.
      //You can set it to false when using production environment.
      isDebugMode: true,
      //configure the the type of payments that your business will accept
      acceptCardPayment: false,
      acceptUSSDPayment: false,
      acceptAccountPayment: false,
      acceptFrancophoneMobileMoney: false,
      acceptGhanaPayment: false,
      acceptMpesaPayment: false,
      acceptRwandaMoneyPayment: false,
      acceptUgandaPayment: true,
      acceptZambiaPayment: false,
    );
    final ChargeResponse response = await flutterwave.initializeForUiPayments();
    return response;
  } catch (error) {
    print(error);
    return null;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:rave_events/screens/Home/generate_qr.dart';
import 'package:rave_events/screens/Home/seat_selection.dart';
import 'package:rave_events/screens/Home/user_data_upload.dart';
import 'dart:math';
import 'dart:io';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import '../../models/user_model.dart';
import '../../shared/loading.dart';

// ignore: must_be_immutable
class PaymentClarity extends StatefulWidget {
  Map<String, dynamic> eventData;
  PaymentClarity({super.key, required this.eventData});

  @override
  State<PaymentClarity> createState() => _PaymentClarityState();
}

class _PaymentClarityState extends State<PaymentClarity> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    String ref = '';
    String eventUid = widget.eventData['id'];

    // ignore: no_leading_underscores_for_local_identifiers
    void _showAdditionalDataForm() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: const UserDataUploadForm(),
            );
          });
    }

    return loading
        ? const Loading()
        : FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('UserData')
                .doc(user!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Make Payment'),
                    centerTitle: true,
                    backgroundColor: Colors.white70,
                    elevation: 0.0,
                    leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.chevron_left)),
                  ),
                  body: Column(
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.blueGrey,
                          elevation: 7.0,
                          child: InkWell(
                            onTap: () async {
                              loading = true;
                              final userData = await FirebaseFirestore.instance
                                  .collection('UserData')
                                  .doc(user.uid)
                                  .get();
                              loading = false;
                              var data = userData.data();
                              var profpic = data?['profpic'];
                              var name = data?['name'];
                              if (profpic == null || name == null) {
                                _showAdditionalDataForm();
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookingScreen(
                                              eventData: widget.eventData,
                                            )));
                              }
                            },
                            child: const Center(
                              child: Text('Pay for VIP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        height: 50.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.blueGrey,
                          elevation: 7.0,
                          child: InkWell(
                            onTap: () async {
                              loading = true;
                              final navigator = Navigator.of(context);
                              final userData = await FirebaseFirestore.instance
                                  .collection('UserData')
                                  .doc(user.uid)
                                  .get();
                              loading = false;
                              final event = await FirebaseFirestore.instance
                                  .collection('Events')
                                  .doc(eventUid)
                                  .get();
                              int ordinarySlots =
                                  int.parse(event.data()?['ordinarySlots']);
                              if (ordinarySlots == null || ordinarySlots <= 0) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    "Event sold out",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ));
                              } else {
                                var data = userData.data();
                                var profpic = data?['profpic'];
                                var name = data?['name'];
                                if (profpic == null || name == null) {
                                  _showAdditionalDataForm();
                                } else {
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
                                  final amount =
                                      widget.eventData['ordinaryPrice'];
                                  if (email!.isEmpty || amount.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Email or Amount Empty"),
                                    ));
                                  } else {
                                    ///Flutter payements
                                    setState(() {
                                      loading = true;
                                    });
                                    ChargeResponse? response =
                                        await _makePayment(
                                            context,
                                            email.trim(),
                                            amount.trim(),
                                            ref,
                                            snapshot.data!.data()!['name']);
                                    setState(() {
                                      loading = false;
                                    });
                                    if (response == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Transaction Failed"),
                                      ));
                                    } else {
                                      if (response.data == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Transaction Failed"),
                                        ));
                                      } else {
                                        if (response.status == "sucess") {
                                          FirebaseFirestore.instance
                                              .collection('Events')
                                              .doc(eventUid)
                                              .update({
                                            'ordinarySlots': ordinarySlots - 1,
                                          });
                                          Map<String, dynamic> paymentDetails =
                                              {
                                            'name': name,
                                            'profpic': profpic,
                                            'vipStatus': 'Ordinary',
                                            'event': widget.eventData['name'],
                                          };
                                          navigator.push(MaterialPageRoute(
                                              builder: (_) => QrCodeScanner(
                                                  paymentDetails:
                                                      paymentDetails)));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("${response.data}"),
                                          ));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("${response.message}"),
                                          ));
                                        } else {
                                          Map<String, dynamic> paymentDetails =
                                              {
                                            'name': name,
                                            'profpic': profpic,
                                            'vipStatus': 'Ordinary',
                                            'event': widget.eventData['name'],
                                          };
                                          navigator.push(MaterialPageRoute(
                                              builder: (_) => QrCodeScanner(
                                                  paymentDetails:
                                                      paymentDetails)));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("${response.message}"),
                                          ));
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            },
                            child: const Center(
                              child: Text('Pay for Ordinary',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                    child:
                        CircularProgressIndicator(color: Colors.greenAccent));
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

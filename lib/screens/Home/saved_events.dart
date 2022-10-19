import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:rave_events/screens/Home/details_page.dart';
import '../../models/user_model.dart';

class SavedEvents extends StatelessWidget {
  const SavedEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back),
          color: Colors.black,
        ),
        title: const Text('Saved Events'),
      ),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(
          10,
        ),
        child: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Cart')
                  .doc(user!.uid)
                  .collection('PersonalCart')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No Bookings Yet",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5.0,
                                    spreadRadius: 2.0,
                                    color: Colors.black12,
                                  ),
                                ]),
                            margin: const EdgeInsets.all(5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                InkWell(
                                  onTap: () {
                                    final event =
                                        snapshot.data!.docs[index].data();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Details(
                                                  eventData: event,
                                                )));
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                    child: Image.network(
                                      snapshot.data!.docs[index]['image'],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data!.docs[index]['name']),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2.0, bottom: 2.0),
                                          child: Text(snapshot.data!.docs[index]
                                              ['location']))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      )),
    );
  }
}

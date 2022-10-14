import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:rave_events/screens/Home/details_page.dart';
import 'package:rave_events/screens/Home/event_upload_form.dart';
import 'package:rave_events/screens/Home/saved_events.dart';
import 'package:rave_events/screens/Home/user_data_update.dart';
import 'package:rave_events/screens/Home/user_portal.dart';
import '../../models/user_model.dart';

var bannerItems = ['concert1', 'concert2', 'concert3', 'concert4'];
var bannerImage = [
  'assets/images/concert1.jpg',
  'assets/images/concert2.jpg',
  'assets/images/concert3.jpg',
  'assets/images/concert4.jpg',
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    // ignore: no_leading_underscores_for_local_identifiers
    void _showEventUploadPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: const EventUploadForm(),
            );
          });
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _pushSaved() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const UserPortal()));
    }

    void _showAdditionalDataForm() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: const UserDataUpdateForm(),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[Colors.grey, Colors.blueGrey]),
              ),
              child: Container(
                child: Column(
                  children: const [
                    Material(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  _pushSaved();
                }),
            ListTile(
                leading: const Icon(Icons.shopping_bag_sharp),
                title: const Text('Bookings'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SavedEvents()));
                }),
            ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Post Events'),
                onTap: () {
                  _showEventUploadPanel();
                }),
            ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Update User Data'),
                onTap: () {
                  _showAdditionalDataForm();
                }),
          ],
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "Popular Events",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey),
                ),
              ),
              const BannerWidgetArea(),
              Container(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Events')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5.0,
                                          spreadRadius: 2.0,
                                          color: Colors.black12,
                                        ),
                                      ]),
                                  margin: const EdgeInsets.all(5.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              bottomLeft:
                                                  Radius.circular(10.0)),
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
                                            Text(snapshot.data!.docs[index]
                                                ['name']),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0, bottom: 2.0),
                                                child: Text(snapshot.data!
                                                    .docs[index]['location']))
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
            ],
          ),
        )),
      ),
    );
  }
}

class BannerWidgetArea extends StatelessWidget {
  const BannerWidgetArea({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    PageController controller =
        PageController(viewportFraction: 0.8, initialPage: 1);

    List<Widget> banners = [];

    for (int x = 0; x < bannerItems.length; x++) {
      var bannerView = Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0),
                  ]),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              child: Image.asset(
                bannerImage[x],
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bannerItems[x],
                    style: const TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        )),
      );
      banners.add(bannerView);
    }

    return Container(
      height: screenWidth * 9 / 16,
      width: screenWidth,
      child: PageView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: banners,
      ),
    );
  }
}

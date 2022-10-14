import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SavedEvents extends StatelessWidget {
  const SavedEvents({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  // onTap: () {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => Details(banners[x], )));
                  // },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)),
                    child: Image.asset(
                      'assets/images/concert2.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("placeName"),
                      Padding(
                          padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: Text('placeLocation'))
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}

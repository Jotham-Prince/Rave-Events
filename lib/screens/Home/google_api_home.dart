import 'package:flutter/material.dart';
import 'package:rave_events/screens/Home/current_location_screen.dart';
import 'package:rave_events/screens/Home/nearby_places_screen.dart';
import 'package:rave_events/screens/Home/polyline_screen.dart';
import 'package:rave_events/screens/Home/search_places_screen.dart';
import 'package:rave_events/screens/Home/simple_map_screen.dart';

class ApiHome extends StatefulWidget {
  const ApiHome({super.key});

  @override
  State<ApiHome> createState() => _ApiHomeState();
}

class _ApiHomeState extends State<ApiHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const SimpleMapScreen();
                  }));
                },
                child: const Text("Simple Map")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const CurrentLocationScreen();
                  }));
                },
                child: const Text("User current location")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const SearchPlacesScreen();
                  }));
                },
                child: const Text("Search Places")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const NearByPlacesScreen();
                  }));
                },
                child: const Text("Near by Places")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const PolylineScreen();
                  }));
                },
                child: const Text("Polyline between 2 points"))
          ],
        ),
      ),
    );
  }
}

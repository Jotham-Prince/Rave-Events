import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 239, 238, 238),
      child: const Center(
        child: SpinKitDualRing(
          color: Colors.green,
          size: 50.0,
        ),
      ),
    );
  }
}

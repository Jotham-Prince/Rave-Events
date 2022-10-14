import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:rave_events/models/user_model.dart';
import 'package:rave_events/screens/Authentication/auth_gate.dart';
import '../../screens/Home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    if (user != null) {
      return const HomeScreen();
    }
    return const AuthGate();
  }
}

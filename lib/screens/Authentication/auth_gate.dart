import 'package:flutter/material.dart';
import 'package:rave_events/screens/Authentication/login_screen.dart';
import 'package:rave_events/screens/Authentication/sign_up_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginScreen(toggleView: toggleView);
    }
    return SignUpScreen(toggleView: toggleView);
  }
}

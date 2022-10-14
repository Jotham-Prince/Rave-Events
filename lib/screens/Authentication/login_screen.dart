import 'package:flutter/material.dart';
import 'package:rave_events/services/auth_service.dart';
import '../../shared/loading.dart';

class LoginScreen extends StatefulWidget {
  final Function? toggleView;
  const LoginScreen({super.key, required this.toggleView});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                        child: const Text(
                          'Hello',
                          style: TextStyle(
                              fontSize: 80.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
                        child: const Text(
                          'User',
                          style: TextStyle(
                              fontSize: 80.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 35.0, left: 20.0, right: 20.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter an email' : null,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              validator: (val) => val!.length < 8
                                  ? 'Enter a password 8+ characters long'
                                  : null,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              obscureText: true,
                            ),
                            const SizedBox(height: 5.0),
                            Container(
                              alignment: const Alignment(1.0, 0.0),
                              padding:
                                  const EdgeInsets.only(top: 15.0, left: 20.0),
                              child: InkWell(
                                onTap: () {},
                                child: const Text(
                                  'forgot password',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 27, 254, 35),
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            Container(
                              height: 50.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.greenAccent,
                                color: const Color.fromARGB(255, 27, 254, 35),
                                elevation: 7.0,
                                child: InkWell(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result = await _auth
                                          .signInWithEmailAndPassword(
                                              email, password);
                                      if (result == null) {
                                        setState(() {
                                          error = 'Invalid user credentials';
                                          loading = false;
                                        });
                                      }
                                    }
                                  },
                                  child: const Center(
                                    child: Text('login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 20.0),
                            // Container(
                            //   height: 40.0,
                            //   color: Colors.transparent,
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       border: Border.all(
                            //         color: Colors.black,
                            //         style: BorderStyle.solid,
                            //         width: 1.0,
                            //       ),
                            //       color: Colors.transparent,
                            //       borderRadius: BorderRadius.circular(20.0),
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: const [
                            //         // Center(
                            //         //   child: ImageIcon(
                            //         //       AssetImage('assets/images/google.png')),
                            //         // ),
                            //         Center(
                            //           child: Text(
                            //             'login with Google',
                            //             style: TextStyle(fontWeight: FontWeight.bold),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New to Rave?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5.0),
                      InkWell(
                        onTap: () {
                          widget.toggleView!();
                        },
                        child: const Text('register here',
                            style: TextStyle(
                                color: Color.fromARGB(255, 27, 254, 35),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline)),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Center(
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  const Center(
                    child: Text(
                      'By logging in you agree to our terms and conditions',
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

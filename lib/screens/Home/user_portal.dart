import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:rave_events/models/user_model.dart';
import '../../services/auth_service.dart';

class UserPortal extends StatelessWidget {
  const UserPortal({super.key});

  @override
  Widget build(BuildContext context) {
    CustomUser? user = Provider.of<CustomUser?>(context);
    // ignore: no_leading_underscores_for_local_identifiers
    final AuthService _auth = AuthService();
    var _email = user?.email;
    var uid = user?.uid;
    if (uid == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('UserData')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('User Profile'),
                centerTitle: true,
                backgroundColor: Colors.grey,
                elevation: 0.0,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.chevron_left)),
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundImage: NetworkImage(snapshot.data!
                                .data()!['profpic'] ??
                            'https://www.pngitem.com/pimgs/m/504-5040528_empty-profile-picture-png-transparent-png.png'),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[800],
                      height: 60.0,
                    ),
                    const Text(
                      'NAME',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      snapshot.data!.data()!['name'] ?? 'No name available',
                      style: TextStyle(
                        color: Color.fromARGB(255, 52, 252, 59),
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          (() {
                            if (_email == null) {
                              return "No email available";
                            } else {
                              return _email;
                            }
                          }()),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50.0),
                    Container(
                      height: 50.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color.fromARGB(255, 52, 252, 59),
                        elevation: 7.0,
                        child: InkWell(
                          onTap: () async {
                            await _auth.sign_out();
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          },
                          child: const Center(
                            child: Text('logout',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }
}

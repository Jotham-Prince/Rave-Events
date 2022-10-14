import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:rave_events/models/user_model.dart';
import 'package:rave_events/services/storage_service.dart';
import 'package:rave_events/shared/loading.dart';
import '../../shared/constants.dart';

class UserDataUpdateForm extends StatefulWidget {
  const UserDataUpdateForm({super.key});

  @override
  State<UserDataUpdateForm> createState() => _UserDataUpdateFormState();
}

class _UserDataUpdateFormState extends State<UserDataUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final Storage storage = Storage();
  String? imageLocation;
  String _name = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return loading
        ? const Loading()
        : Scaffold(
            body: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Text(
                    'Update User Data',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final results = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg'],
                      );
                      if (results == null) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('No File Selected'),
                        ));
                        return null;
                      }
                      final path = results.files.single.path;
                      final fileName = results.files.single.name;
                      storage.uploadPic(path!, fileName);
                      String imgUrl = await FirebaseStorage.instance
                          .ref('ProfilePics/$fileName')
                          .getDownloadURL();
                      setState(() {
                        imageLocation = imgUrl;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.green[400], //ripple color
                    ),
                    child: const Text(
                      'Upload Profile Picture',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Name'),
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter your name' : null,
                      onChanged: (val) {
                        setState(() {
                          _name = val;
                        });
                      }),
                  const SizedBox(
                    height: 20.0,
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
                          setState(() {
                            loading = true;
                          });
                          final CollectionReference userDataDocument =
                              FirebaseFirestore.instance.collection('UserData');
                          try {
                            await userDataDocument.doc(user!.uid).update({
                              'profpic': imageLocation,
                              'name': _name,
                            });
                          } catch (e) {
                            print(e.toString());
                            return null;
                          }
                          setState(() {
                            loading = false;
                          });
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        child: const Center(
                          child: Text('Update Data',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          );
  }
}

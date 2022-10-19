import 'package:date_field/date_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:rave_events/services/database_service.dart';
import 'package:rave_events/services/storage_service.dart';
import 'package:rave_events/shared/constants.dart';
import '../../models/user_model.dart';
import '../../shared/loading.dart';

class EventUploadForm extends StatefulWidget {
  const EventUploadForm({super.key});

  @override
  State<EventUploadForm> createState() => _EventUploadFormState();
}

class _EventUploadFormState extends State<EventUploadForm> {
  final _formKey = GlobalKey<FormState>();
  final Storage storage = Storage();
  String eventName = '';
  String _eventOrganizer = '';
  late DateTime selectedData;
  late String imageLocation;
  String owner = '';
  String eventLocation = '';
  final now = DateTime.now();
  bool loading = false;
  String _ordinarySlots = '0';
  String? _vipSlots;
  String _ordinaryPrice = '0';
  String? _vipPrice;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    setState(() {
      owner = user!.uid;
    });

    return loading
        ? const Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Create Your Event',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Name'),
                        validator: (val) => val!.isEmpty
                            ? 'Please enter a name for your event'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            eventName = val;
                          });
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Location'),
                        validator: (val) => val!.isEmpty
                            ? 'Please enter a location for your event'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            eventLocation = val;
                          });
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Organizer(s)'),
                        validator: (val) => val!.isEmpty
                            ? 'Please enter the event organizer(s)'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            _eventOrganizer = val;
                          });
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Number of Ordinary Slots'),
                        keyboardType: TextInputType.number,
                        validator: (val) => val!.isEmpty
                            ? 'Please enter a number of Ordinary slots'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            _ordinarySlots = val;
                          });
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Price for Ordinary in Ugx'),
                        keyboardType: TextInputType.number,
                        validator: (val) => val!.isEmpty
                            ? 'Please enter a Price for Ordinary'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            _ordinaryPrice = val;
                          });
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Number of VIP Seats (Optional)'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          setState(() {
                            _vipSlots = val;
                          });
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Price for VIP in Ugx (Optional)'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          setState(() {
                            _vipPrice = val;
                          });
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Date and time',
                      ),
                      mode: DateTimeFieldPickerMode.dateAndTime,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) {
                        var f = e;
                        if (f == null) {
                          return "Please input a date";
                        } else if (f.compareTo(now) < 0) {
                          return "You cannot use a past date";
                        } else {
                          return null;
                        }
                      },
                      onDateSelected: (DateTime val) {
                        selectedData = val;
                        print(val);
                      },
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
                        storage.uploadFile(path!, fileName);
                        String imgUrl = await FirebaseStorage.instance
                            .ref('EventCovers/$fileName')
                            .getDownloadURL();
                        imageLocation = imgUrl;
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.green[400], //ripple color
                      ),
                      child: const Text(
                        'Upload Event Cover',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text("Event won't upload without a cover",
                        style: TextStyle(color: Colors.red)),
                    const SizedBox(
                      height: 20.0,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          await DatabaseService(uid: user!.uid).createEvent(
                              name: eventName,
                              organiser: _eventOrganizer,
                              date: selectedData,
                              img: imageLocation,
                              owner: owner,
                              location: eventLocation,
                              vipPrice: _vipPrice,
                              ordinaryPrice: _ordinaryPrice,
                              ordinarySlots: _ordinarySlots,
                              vipSlots: _vipSlots);
                          setState(() {
                            loading = false;
                          });
                          Navigator.pop(context);
                        }
                      },
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.add),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

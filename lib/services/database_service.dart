import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rave_events/models/events_model.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //Events collection reference
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('Events');

  //UserData Collection reference
  final CollectionReference userDataDocument =
      FirebaseFirestore.instance.collection('UserData');

  //To update/create user data

  //To upload an event to cloud Firestore
  Future<void> createEvent({
    required String name,
    required String organiser,
    required DateTime date,
    required String img,
    required String owner,
    required String location,
    required String ordinaryPrice,
    String? vipPrice,
    required String ordinarySlots,
    String? vipSlots,
  }) async {
    try {
      //Reference to our event on cloud firestore
      final docRef = eventsCollection.doc();

      final event = Event(
        id: docRef.id,
        name: name,
        organizer: organiser,
        date: date,
        img: img,
        owner: owner,
        location: location,
        ordinaryPrice: ordinaryPrice,
        vipSlots: vipSlots,
        ordinarySlots: ordinarySlots,
        vipPrice: vipPrice,
      );
      final json = event.toJson();
      //Create document and write data to cloud firestore
      await docRef.set(json);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //A function to convert a QuerySnapshot to a list of events
  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map;
      return Event(
        id: data['id'],
        name: data['name'],
        organizer: data['organizer'],
        date: data['date'],
        img: data['img'],
        owner: data['owner'],
        location: data['location'],
        ordinaryPrice: data['ordinaryPrice'],
        vipPrice: data['vipPrice'],
        ordinarySlots: data['ordinarySlots'],
        vipSlots: data['vipSlots'],
      );
    }).toList();
  }

  //A Stream of events
  Stream<List<Event>> get eventList {
    return eventsCollection.snapshots().map(_eventListFromSnapshot);
  }

  //A function to convert a QuerySnapshot to a json file of events
  List<Map<dynamic, dynamic>> _eventJsonFromQuerySnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => doc.data() as Map).toList();
  }

  //A Stream of Json files to display on the home screen
  List<Map<String, dynamic>>? get eventJson {
    try {
      QuerySnapshot eventsq =
          eventsCollection.snapshots() as QuerySnapshot<Object?>;
      return eventsq.docs.map((doc) {
        var data = doc.data() as Map;
        return {
          'id': data['id'],
          'placeName': data['name'],
          'placeImage': data['img'],
          'placeLocation': data['location'],
        };
      }).toList();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //A Function to create the user data
  Future createUserData(String? profpic, String? name, bool? vipStatus) async {
    try {
      return await userDataDocument.doc(uid).set({
        'profpic': profpic,
        'name': name,
        'vipStatus': vipStatus ?? false,
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

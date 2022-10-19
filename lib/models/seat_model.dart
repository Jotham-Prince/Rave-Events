import 'package:cloud_firestore/cloud_firestore.dart';

class Seat {
  int? seatNo;

  Seat({this.seatNo});

  Seat fromDocumentSnapshot(QueryDocumentSnapshot seat) {
    return Seat(seatNo: seat['number']);
  }
}

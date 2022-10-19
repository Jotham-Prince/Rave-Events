class Event {
  String id;
  String name;
  String organizer;
  DateTime date;
  String img;
  String owner;
  String location;
  String? vipSlots;
  String ordinarySlots;
  String? vipPrice;
  String ordinaryPrice;

  Event({
    required this.id,
    required this.name,
    required this.organizer,
    required this.date,
    required this.img,
    required this.owner,
    required this.location,
    required this.ordinaryPrice,
    this.vipPrice,
    required this.ordinarySlots,
    this.vipSlots,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'organiser(s)': organizer,
        'date': date,
        'image': img,
        'owner': owner,
        'location': location,
        'ordinaryPrice': ordinaryPrice,
        'vipPrice': vipPrice ?? '',
        'ordinarySlots': ordinarySlots,
        'vipSlots': vipSlots ?? '',
      };

  /*static Event fromJson(Map<String, dynamic> json) => Event(
      id: json['id'],
      name: json['name'],
      organizer: json['organiser(s)'],
      date: json['date'],
      img: json['image'],
      owner: json['owner'],
      location: json['location'], ordinaryPrice: null);*/
}

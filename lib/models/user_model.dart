class CustomUser {
  final String uid;
  final String? email;

  CustomUser({
    required this.uid,
    this.email,
  });
}

class UserData {
  final String profpic;
  final String name;
  final bool vipStatus = false;

  UserData({required this.profpic, required this.name});
}

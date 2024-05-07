class AGUser {
  final String uid;
  final String username;
  final String address;
  final String phone;
  final String profilePic;
  final double latitude;
  final double longitude;

  AGUser({
    required this.uid,
    required this.username,
    required this.address,
    required this.phone,
    required this.profilePic,
    required this.latitude,
    required this.longitude,
  });

  factory AGUser.fromJson(Map<dynamic, dynamic> json) {
    return AGUser(
      uid: json['uid'],
      username: json['AGUsername'],
      address: json['address'],
      phone: json['phone'],
      profilePic: json['profilePic'],
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
    );
  }
}

class UserModel {
  int? id;
  String name;
  String? email;
  String? password;
  String language;
  String? city;
  double? latitude;
  double? longitude;

  UserModel({
    this.id,
    required this.name,
    this.email,
    this.password,
    required this.language,
    this.city,
    this.latitude,
    this.longitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      language: json['language'],
      city: json['city'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

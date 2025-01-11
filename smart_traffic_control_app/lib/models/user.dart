import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String phoneNumber;
  @HiveField(4)
  final String country;
  @HiveField(5)
  final String countyOrState;
  @HiveField(6)
  final String city;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.countyOrState,
    required this.city,
  });

  // receive data from the server and convert it to a User object
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        country: json['country'],
        countyOrState: json['countyOrState'],
        city: json['city'],
      );

  // convert the User object to a JSON object to send to the server
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'country': country,
        'countyOrState': countyOrState,
        'city': city,
      };

  User getValue() {
    return User(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      country: country,
      countyOrState: countyOrState,
      city: city,
    );
  }
}

import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String username;
  @HiveField(3)
  final String firstName;
  @HiveField(4)
  final String lastName;
  @HiveField(5)
  final String phoneNumber;
  @HiveField(6)
  final String country;
  @HiveField(7)
  final String countyOrState;
  @HiveField(8)
  final String city;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.country,
    required this.countyOrState,
    required this.city,
  });

  // receive data from the server and convert it to a User object
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'].toString(),
        email: json['email'],
        username: json['username'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        phoneNumber: json['profile']['phone'],
        country: json['profile']['country'],
        countyOrState: json['profile']['county_or_state'],
        city: json['profile']['city'],
      );

  // convert the User object to a JSON object to send to the server
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'profile': {
          'phone': phoneNumber,
          'country': country,
          'county_or_state': countyOrState,
          'city': city
        }
      };

  User getValue() {
    return User(
      id: id,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      country: country,
      countyOrState: countyOrState,
      city: city,
    );
  }
}

import 'package:equatable/equatable.dart';

/// [User]
/// A User model class

class User extends Equatable {
  User({required this.name, required this.city, required this.profession});

  User.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] as String,
        city = json['city'] as String,
        profession = json['profession'] as String;

  String name;
  String city;
  String profession;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['city'] = city;
    data['profession'] = profession;
    return data;
  }

  @override
  List<Object> get props => [name, city, profession];

  @override
  String toString() =>
      {'name': name, 'city': city, 'profession': profession}.toString();
}

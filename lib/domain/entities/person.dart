import 'package:fullfit_app/config/extensions/string_extensions.dart';

class Person {
  final String id;
  final String name;
  final String lastname;
  final double weight;
  final double height;
  final int age;
  final String gender;
  final String email;
  final String profilePic;

  Person({
    required this.id,
    required this.gender,
    required this.email,
    required this.profilePic,
    required this.name,
    required this.lastname,
    required this.age,
    required this.weight,
    required this.height,
  });

  get fullName => '${name.capitalize()} ${lastname.capitalize()}';
}

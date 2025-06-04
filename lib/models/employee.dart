import 'package:invenza/interface/contactable.dart';
import 'package:invenza/models/association.dart';

class Employee implements Contactable {
  @override
  final String name;
  @override
  final String id;
  @override
  final Association association;
  final String? jwtToken;

  Employee(this.name, this.id, this.association, {this.jwtToken});

  Map<String, dynamic> toJson() => {
    "name" : name,
    "id" : id,
    "association" : association.toJson(),
  };
}
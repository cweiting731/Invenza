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

  String getName() {
    return name;
  }
  String getID() {
    return id;
  }
  String getAssociation() {
    return '''
        phone: ${association.phone ?? ''} 
        email: ${association.email ?? ''}
      ''';
  }
}
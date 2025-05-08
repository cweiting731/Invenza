import 'package:invenza/models/Contactable.dart';
import 'package:invenza/models/association.dart';

class Employee implements Contactable {
  final String name;
  final String id;
  final Association association;

  Employee(this.name, this.id, this.association);

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
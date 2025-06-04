import 'package:invenza/interface/contactable.dart';

import 'association.dart';

class BusinessPartner implements Contactable{
  @override
  final String name;
  @override
  final String id;
  @override
  final Association association;

  BusinessPartner(this.name, this.id, this.association);

  Map<String, dynamic> toJson() => {
    "name" : name,
    "id" : id,
    "association" : association.toJson()
  };

}
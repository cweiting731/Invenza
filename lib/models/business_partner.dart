import 'package:invenza/interface/contactable.dart';

import 'association.dart';

class BusinessPartner implements Contactable{
  final String name;
  final String id;
  final Association association;

  BusinessPartner(this.name, this.id, this.association);

}
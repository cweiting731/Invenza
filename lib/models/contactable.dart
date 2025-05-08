import 'package:invenza/models/association.dart';

abstract class Contactable {
  String get name;
  String get id;
  Association get association;
}
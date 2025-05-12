import 'dart:convert';

import 'package:invenza/interface/serializable.dart';

class Condition implements Serializable{
  final String type;
  final Map<String, dynamic> data;

  Condition(this.type, this.data);

  @override
  String serialization() {
    Map<String, dynamic> textMap =  {
      'type' : type,
      'data' : data,
    };
    return jsonEncode(textMap);
  }

  @override
  Map<String, dynamic> serialization_json() {
    // TODO: implement serialization_json
    throw UnimplementedError();
  }
}

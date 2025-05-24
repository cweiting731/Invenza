import 'dart:convert';

import 'package:invenza/interface/serializable.dart';

class ForgotPasswordData implements Serializable {
  final String email;

  ForgotPasswordData(this.email);

  @override
  String serialization() {
    return jsonEncode(
      {
        'email' : email,
      }
    );
  }

  @override
  void deserialization() {
    // TODO: implement deserialization
  }
}
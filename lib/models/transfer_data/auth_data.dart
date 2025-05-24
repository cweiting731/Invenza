import 'dart:convert';

import 'package:invenza/interface/serializable.dart';

class AuthData implements Serializable{
  final String account;
  final String password;
  AuthData(this.account, this.password);

  @override
  String serialization() {
    return jsonEncode(
      {
        'account' : account,
        'password' : password,
      }
    );
  }

  @override
  void deserialization() {
    // TODO: implement deserialization
  }

}
import 'dart:convert';

import 'package:invenza/interface/serializable.dart';

class AuthData implements Serializable{
  String account;
  String password;
  AuthData(this.account, this.password);

  @override
  String serialization() {
    // TODO: implement serialization
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> serialization_json() {
    return {
      'account' : account,
      'password' : password,
    };
  }
}
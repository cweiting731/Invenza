import 'dart:convert';

import 'package:invenza/interface/serializable.dart';
import 'package:invenza/models/commodity.dart';
import 'package:invenza/models/employee.dart';

enum RequestTarget {
  procurement,
  saler,
}
extension RequestTargetExtension on RequestTarget {
  String get displayName {
    switch (this) {
      case RequestTarget.procurement:
        return '採購部';
      case RequestTarget.saler:
        return '銷售部';
    }
  }
}

class InventoryRequest implements Serializable{
  final Commodity commodity;
  final double requestQuantity; // 申請的數量
  final RequestTarget target;
  final Employee responsible; // 負責人

  InventoryRequest({
    required this.commodity,
    required this.requestQuantity,
    required this.target,
    required this.responsible,
  });

  @override
  String serialization() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'commodityName': commodity.name,
      'commodityType': commodity.type,
      'requestQuantity': requestQuantity,
      'target': target.toString().split('.').last,
      'responsible': responsible.toJson(),
    };
  }
}
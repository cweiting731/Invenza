import 'dart:convert';

import 'package:invenza/interface/serializable.dart';
import 'package:invenza/models/employee.dart';

enum RequestTarget {
  procurement,
  saler,
}
class InventoryRequest implements Serializable{
  final String commodityName;
  final String commodityType;
  final double stockQuantity;
  final double futureStockQuantity; // 未加倉管要求的數量
  final double requestQuantity; // 申請的數量
  final RequestTarget target;
  final Employee responsible; // 負責人

  InventoryRequest({
    required this.commodityName,
    required this.commodityType,
    required this.stockQuantity,
    required this.futureStockQuantity,
    required this.requestQuantity,
    required this.target,
    required this.responsible,
  });

  @override
  String serialization() {
    return jsonEncode(this.toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'commodityName': commodityName,
      'commodityType': commodityType,
      'stockQuantity': stockQuantity,
      'futureStockQuantity': futureStockQuantity,
      'requestQuantity': requestQuantity,
      'target': target.toString().split('.').last,
    };
  }
}
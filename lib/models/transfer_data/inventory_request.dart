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
  final int? id; // 申請的ID，可能來自後端
  final Commodity commodity;
  final double requestQuantity; // 申請的數量
  final RequestTarget target;
  final Employee responsible; // 負責人
  Employee? checker;
  bool isFinished; // 是否已完成

  InventoryRequest({
    this.id,
    required this.commodity,
    required this.requestQuantity,
    required this.target,
    required this.responsible,
    this.checker,
    this.isFinished = false,
  });

  @override
  String serialization() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // 如果有ID，則包含在JSON中
      'commodityName': commodity.name,
      'commodityType': commodity.type,
      'requestQuantity': requestQuantity,
      'target': target.toString().split('.').last,
      'responsible': responsible.toJson(),
      'checker': checker?.toJson(),
      'isFinished': isFinished,
    };
  }

  factory InventoryRequest.fromJson(Map<String, dynamic> json) {
    return InventoryRequest(
      id: json['id'], // 從JSON中獲取ID
      commodity: Commodity(json['commodityName'], json['commodityType'], null),
      requestQuantity: json['requestQuantity'],
      target: RequestTarget.values.firstWhere((e) => e.toString() == 'RequestTarget.${json['target']}'),
      responsible: Employee.fromJson(json['responsible']),
      checker: json['checker'] != null ? Employee.fromJson(json['checker']) : null,
      isFinished: json['isFinished'] ?? false,
    );
  }
}
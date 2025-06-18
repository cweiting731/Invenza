import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:invenza/interface/serializable.dart';
import 'package:invenza/models/business_partner.dart';
import 'package:invenza/models/commodity.dart';
import 'package:invenza/models/employee.dart';

class ExportOrder implements Serializable {
  int? id;
  Commodity? commodity;
  BusinessPartner? distributor;
  DateTime? orderTimeStamp;
  DateTime? deadlineTimeStamp;
  Employee? responsible;

  ExportOrder({
    this.id,
    this.commodity,
    this.distributor,
    this.orderTimeStamp,
    this.deadlineTimeStamp,
    this.responsible,
  });

  factory ExportOrder.fromJson(Map<String, dynamic> json) {
    final commodity = json['commodity'];
    final distributor = json['distributor'];
    final responsible = json['responsible'];

    DateTime? orderTimeStamp;
    DateTime? deadlineTimeStamp;

    try {
      orderTimeStamp = DateTime.parse(json['orderTimeStamp']);
    } catch (_) {
      orderTimeStamp = null;
    }

    try {
      deadlineTimeStamp = DateTime.parse(json['deadlineTimeStamp']);
    } catch (_) {
      deadlineTimeStamp = null;
    }

    return ExportOrder(
      id: json['id'],
      commodity: Commodity.fromJson(commodity),
      distributor: BusinessPartner.fromJson(distributor),
      orderTimeStamp: orderTimeStamp,
      deadlineTimeStamp: deadlineTimeStamp,
      responsible: Employee.fromJson(responsible),
    );
  }

  @override
  String serialization() {
    final formatter = DateFormat("yyyy-MM-dd HH:mm");
    return jsonEncode({
      "id": id,
      "commodity": commodity?.toJson(),
      "distributor": distributor?.toJson(),
      "orderTimeStamp": orderTimeStamp != null ? formatter.format(orderTimeStamp!) : null,
      "deadlineTimeStamp": deadlineTimeStamp != null ? formatter.format(deadlineTimeStamp!) : null,
      "responsible": responsible?.toJson(),
    });
  }
}
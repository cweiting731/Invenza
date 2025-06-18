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

  static String? parseDateTime(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  String serialization() {
    return jsonEncode({
      "id": id,
      "commodity": commodity?.toJson(),
      "distributor": distributor?.toJson(),
      "orderTimeStamp": parseDateTime(orderTimeStamp),
      "deadlineTimeStamp": parseDateTime(deadlineTimeStamp),
      "responsible": responsible?.toJson(),
    });
  }
}
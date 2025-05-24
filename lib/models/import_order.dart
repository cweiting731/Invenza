import 'package:invenza/models/association.dart';
import 'package:invenza/models/business_partner.dart';
import 'package:invenza/models/commodity.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/models/transaction_value.dart';

class ImportOrder {
  // 進貨單ID(系統自動給)、商品名稱、型號、供應商名稱、供應商編號、供應商聯絡方式、進貨單價、進貨數量、進貨總價、訂單日期、進貨日期、填單負責人(根據login資料自動填入)
  int? id;
  Commodity? commodity;
  BusinessPartner? supplier;
  DateTime? orderTimeStamp;
  DateTime? deadlineTimeStamp;
  Employee? responsible;

  ImportOrder({this.responsible, this.id, this.commodity, this.supplier, this.orderTimeStamp, this.deadlineTimeStamp});

  factory ImportOrder.fromJson(Map<String, dynamic> json) {
    final commodity = json['commodity'];
    final supplier = json['supplier'];
    final responsible = json['responsible'];
    return ImportOrder(
      id: json['id'],
      commodity: Commodity(
          commodity['name'],
          commodity['type'],
          TransactionValue(
              unitPrice: commodity['transactionValue']['unitPrice'],
              quantity: commodity['transactionValue']['quantity'],
              totalCost: commodity['transactionValue']['totalCost']
          ),
      ),
      supplier: BusinessPartner(
          supplier['name'],
          supplier['id'],
          Association(
            email: supplier['association']['email'],
            phone: supplier['association']['phone']
          )
      ),
      orderTimeStamp: DateTime.parse(json['orderTimeStamp']),
      deadlineTimeStamp: DateTime.parse(json['deadlineTimeStamp']),
      responsible: Employee(
          responsible['name'],
          responsible['id'],
          Association(
            email: responsible['association']['email'],
            phone: responsible['association']['phone']
          )
      )
    );
  }
}
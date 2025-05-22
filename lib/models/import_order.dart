import 'package:invenza/models/business_partner.dart';
import 'package:invenza/models/commodity.dart';

class ImportOrder {
  // 進貨單ID(系統自動給)、商品名稱、型號、供應商名稱、供應商編號、供應商聯絡方式、進貨單價、進貨數量、進貨總價、訂單日期、進貨日期、填單負責人(根據login資料自動填入)
  int? id;
  Commodity? commodity;
  BusinessPartner? supplier;
  String? orderTimeStamp;
  String? deadlineTimeStamp;
  String responsible;

  ImportOrder(this.responsible, {this.id, this.commodity, this.supplier, this.orderTimeStamp, this.deadlineTimeStamp});

  factory ImportOrder.fromJson(Map<String, dynamic> json) {
    return ImportOrder(json['responsible']);
  }
}
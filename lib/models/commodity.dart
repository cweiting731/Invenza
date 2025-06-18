import 'package:invenza/models/transaction_value.dart';

class Commodity {
  String name;
  String type;
  TransactionValue? transactionValue;
  Commodity(this.name, this.type, this.transactionValue);

  Map<String, dynamic> toJson() => {
    "name" : name,
    "type" : type,
    "transactionValue" : transactionValue?.toJson()
  };

  factory Commodity.fromJson(Map<String, dynamic> json) {
    final transactionValue = json['transactionValue'];
    return Commodity(
      json['name'],
      json['type'],
      transactionValue != null ? TransactionValue.fromJson(transactionValue) : null,
    );
  }
}
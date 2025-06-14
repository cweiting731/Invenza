import 'package:flutter/services.dart';

class TransactionValue {
  double unitPrice;
  double quantity;
  double totalCost;

  TransactionValue({this.unitPrice = 0, this.quantity = 0, this.totalCost = 0});

  static double autoFillTotalCost({required double unitPrice, required double quantity}) {
    return unitPrice * quantity;
  }

  static double autoFillUnitPrice({required double totalCost, required double quantity}) {
    return quantity != 0 ? totalCost / quantity : 0;
  }

  static double autoFillQuantity({required double totalCost, required double unitPrice}) {
    return unitPrice != 0 ? totalCost / unitPrice : 0;
  }

  static TransactionValue? autoFill({
    double? unitPrice,
    double? quantity,
    double? totalCost,
  }) {
    if (unitPrice != null && quantity != null && totalCost != null) {
      return null;
    }
    if (unitPrice != null && quantity != null) {
      return TransactionValue(unitPrice: unitPrice, quantity: quantity, totalCost: autoFillTotalCost(unitPrice: unitPrice, quantity: quantity));
    } else if (totalCost != null && quantity != null) {
      return TransactionValue(unitPrice: autoFillUnitPrice(totalCost: totalCost, quantity: quantity), quantity: quantity, totalCost: totalCost);
    } else if (totalCost != null && unitPrice != null) {
      return TransactionValue(unitPrice: unitPrice, quantity: autoFillQuantity(totalCost: totalCost, unitPrice: unitPrice), totalCost: totalCost);
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    "unitPrice" : unitPrice,
    "quantity" : quantity,
    "totalCost" : totalCost
  };
}

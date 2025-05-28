import 'package:invenza/models/commodity.dart';

class InventoryItem {
  Commodity commodity;
  double stockQuantity;
  double expectedImportQuantity;
  double expectedExportQuantity;
  double futureStockQuantity;

  InventoryItem(this.commodity, this.stockQuantity, this.expectedImportQuantity, this.expectedExportQuantity, this.futureStockQuantity);

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    final commodity = json['commodity'];
    return InventoryItem(
      Commodity(
        commodity['name'],
        commodity['type'],
        null
      ),
      json['stockQuantity'],
      json['expectedImportQuantity'],
      json['expectedExportQuantity'],
      json['futureStockQuantity']
    );
  }
}
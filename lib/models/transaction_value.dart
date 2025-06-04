class TransactionValue {
  double unitPrice;
  double quantity;
  double totalCost;

  TransactionValue({this.unitPrice = 0, this.quantity = 0, this.totalCost = 0});

  Map<String, dynamic> toJson() => {
    "unitPrice" : unitPrice,
    "quantity" : quantity,
    "totalCost" : totalCost
  };
}

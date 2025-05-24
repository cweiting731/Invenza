class FilterOptions {
  final String? commodityName;
  final String? commodityType;
  final String? businessPartner;
  final DateTime? orderTime;
  final DateTime? deadline;
  final String? responsible;
  final int? startIndex;
  final int? amount;


  FilterOptions({
    this.commodityName,
    this.commodityType,
    this.businessPartner,
    this.orderTime,
    this.deadline,
    this.responsible,
    this.startIndex,
    this.amount
  });

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};
    if (commodityName != null) params['commodityName'] = commodityName!;
    if (commodityType != null) params['commodityType'] = commodityType!;
    if (businessPartner != null) params['businessPartner'] = businessPartner!;
    if (orderTime != null) params['orderTime'] = orderTime!.toIso8601String();
    if (deadline != null) params['deadline'] = deadline!.toIso8601String();
    if (responsible != null) params['responsible'] = responsible!;
    if (startIndex != null) params['startIndex'] = startIndex!.toString();
    if (startIndex != null) params['amount'] = amount!.toString();
    return params;
  }

}
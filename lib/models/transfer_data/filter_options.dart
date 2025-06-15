import 'package:intl/intl.dart';
enum InventoryFilterType {
  inventoryNow, 
  inventoryFuture,
}
class FilterOptions {
  final String? commodityName;
  final String? commodityType;

  /// Procurement/SalesRecords page
  final String? businessPartner;
  final String? businessPartnerId;
  final DateTime? orderTimeStart;
  final DateTime? orderTimeEnd;
  final DateTime? deadlineStart;
  final DateTime? deadlineEnd;

  /// Inventory page
  final double? minAmount;
  final double? maxAmount;
  final InventoryFilterType? inventoryFilterType;

  final String? responsible;
  final String? responsibleId;


  FilterOptions({
    this.commodityName,
    this.commodityType,
    this.businessPartner,
    this.businessPartnerId,
    this.orderTimeStart,
    this.orderTimeEnd,
    this.deadlineStart,
    this.deadlineEnd,
    this.minAmount,
    this.maxAmount,
    this.inventoryFilterType,
    this.responsible,
    this.responsibleId,
  });

  Map<String, String> toQueryParams() {
    final format = DateFormat("yyyy-MM-dd HH:mm");
    final Map<String, String> params = {};
    if (commodityName != null) params['commodityName'] = commodityName!;
    if (commodityType != null) params['commodityType'] = commodityType!;
    if (businessPartner != null) params['businessPartner'] = businessPartner!;
    if (businessPartnerId != null) params['businessPartnerId'] = businessPartnerId!;
    if (orderTimeStart != null) params['orderTimeStart'] = format.format(orderTimeStart!);
    if (orderTimeEnd != null) params['orderTimeEnd'] = format.format(orderTimeEnd!);
    if (deadlineStart != null) params['deadlineStart'] = format.format(deadlineStart!);
    if (deadlineEnd != null) params['deadlineEnd'] = format.format(deadlineEnd!);
    if (minAmount != null) params['minAmount'] = minAmount!.toString();
    if (maxAmount != null) params['maxAmount'] = maxAmount!.toString();
    if (inventoryFilterType != null) params['inventoryFilterType'] = inventoryFilterType!.toString().split('.').last;
    if (responsible != null) params['responsible'] = responsible!;
    if (responsibleId != null) params['responsibleId'] = responsibleId!;
    // Ensure all values are non-null and converted to strings
    return params;
  }

}
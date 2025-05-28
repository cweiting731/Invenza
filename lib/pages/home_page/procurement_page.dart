
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/association.dart';
import 'package:invenza/models/business_partner.dart';
import 'package:invenza/models/commodity.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/models/import_order.dart';
import 'package:invenza/models/transaction_value.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/providers/api_provider.dart';

import '../../providers/procurement_provider.dart';

class ProcurementPage extends ConsumerStatefulWidget {
  const ProcurementPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProcurementPageState();
}

class _ProcurementPageState extends ConsumerState<ProcurementPage> {
  late FilterOptions _filters;

  @override
  void initState() {
    _filters = FilterOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncOrders = ref.watch(importOrdersProvider(_filters));
    final api = ref.read(apiClientProvider);
    return asyncOrders.when(
      loading: () => Center(child: CircularProgressIndicator(),),
      error: (err, _) => Center(child: Text(api.formatErrorMessage(err)),),
      data: (orders) {
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Text('${order.id ?? '?'}'),
                subtitle: Text('${order.commodity?.name ?? '查無商品名稱'} / ${order.commodity?.type ?? '查無商品型號'}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('單價: ${order.commodity?.transactionValue?.unitPrice ?? '查無商品單價'}'),
                        Text('數量: ${order.commodity?.transactionValue?.quantity ?? '查無商品數量'}'),
                        Text('總價: ${order.commodity?.transactionValue?.totalCost ?? '查無商品總價'}'),
                        SizedBox(height: 4,),
                        Text('供應商: ${order.supplier?.name ?? '查無供應商名稱'}'),
                        Text('供應商email: ${order.supplier?.association.email ?? '查無供應商email'}'),
                        Text('供應商電話: ${order.supplier?.association.phone ?? '查無供應商電話'}'),
                        SizedBox(height: 4,),
                        Text('下單日期: ${order.orderTimeStamp ?? '查無下單日期'}'),
                        Text('截止日期: ${order.deadlineTimeStamp ?? '查無截止日期'}'),
                        Text('負責人: ${order.responsible ?? '查無負責人'}'),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );



  }
}

final fakeData = [
  ImportOrder(responsible: Employee('admin', "F00001", Association(email: "admin@gmail.com", phone: "0912345678"), jwtToken: 'admin'),
    id: 0001,
    commodity: Commodity('apple', 'fruit', TransactionValue(unitPrice: 1, quantity: 10, totalCost: 10)),
    supplier: BusinessPartner('成大', '0001', Association(),),
    orderTimeStamp: DateTime(2025, 5, 22),
    deadlineTimeStamp: DateTime(2025, 6, 21),
  ),
  ImportOrder(responsible: Employee('procurement officer1', "400001", Association(email: "procurement1@gmail.com", phone: "0912345678"), jwtToken: 'procurement1'),
    id: 0002,
    commodity: Commodity('banana', 'fruit', TransactionValue(unitPrice: 2, quantity: 50, totalCost: 100)),
    supplier: BusinessPartner('成大', '0001', Association(),),
    orderTimeStamp: DateTime(2025, 5, 21),
    deadlineTimeStamp: DateTime(2025, 6, 22),
  ),
  ImportOrder(responsible: Employee('procurement officer2', "400002", Association(email: "procurement2@gmail.com", phone: "0912345678"), jwtToken: 'procurement2'),
    id: 0003,
    commodity: Commodity('potato', 'plant', TransactionValue(unitPrice: 0.5, quantity: 100, totalCost: 50)),
    supplier: BusinessPartner('成大', '0001', Association(),),
    orderTimeStamp: DateTime(2025, 4, 21),
    deadlineTimeStamp: DateTime(2025, 6, 21),
  ),
];
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/inventory_provider.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  late FilterOptions _filters;

  @override
  void initState() {
    _filters = FilterOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncItems = ref.watch(inventoryItemsProvider(_filters));
    final api = ref.read(apiClientProvider);
    return asyncItems.when(
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
                title: Text('${order.commodity.name ?? '查無商品名稱'} / ${order.commodity.type ?? '查無商品型號'}'),
                subtitle: Text('庫存數量: ${order.stockQuantity}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('預期進貨數量: ${order.expectedImportQuantity}'),
                        Text('預期出貨數量: ${order.expectedExportQuantity}'),
                        Text('預期未來庫存: ${order.futureStockQuantity}'),
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
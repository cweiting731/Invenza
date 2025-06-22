import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/inventory_item.dart';
import 'package:invenza/pages/home_page/edit_inventory_filter.dart';
import 'package:invenza/pages/home_page/edit_inventory_request.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/providers/inventory_provider.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncItems = ref.watch(inventoryItemsProvider);
    final api = ref.read(apiClientProvider);
    final haveInventoryPermission = ref.read(authProvider.notifier).haveInventoryPermission() && false;
    // final haveInventoryPermission = ref.read(authProvider.notifier).haveInventoryPermission();

    return Scaffold(
      appBar: AppBar(
        title: const Text('庫存管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterOption(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(inventoryItemsProvider), 
          ),
        ],
      ),
      floatingActionButton: haveInventoryPermission
          ? FloatingActionButton(
              onPressed: () => _openEditInventoryRequestPage(),
              tooltip: '新增庫存請求',
              child: const Icon(Icons.add),
            )
          : null,
      body: asyncItems.when(
        loading: () => const Center(child: CircularProgressIndicator(),),
        error: (err, _) => Center(child: Text(api.formatErrorMessage(err)),),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('目前沒有庫存資料'),);
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: InkWell(
                  onLongPress: () {
                    // 這裡可以添加長按事件的處理邏輯
                    if (haveInventoryPermission) {
                      _openEditInventoryRequestPage(inventoryItem: item);
                    }
                  },
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text('${item.commodity?.name ?? '查無商品名稱'} / ${item.commodity?.type ?? '查無商品型號'}'),
                    subtitle: Text('庫存數量: ${item.stockQuantity ?? '查無庫存數量'}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('預期進貨數量: ${item.expectedImportQuantity ?? '查無預期進貨數量'}'),
                            Text('預期出貨數量: ${item.expectedExportQuantity ?? '查無預期出貨數量'}'),
                            Text('預期未來庫存: ${item.futureStockQuantity ?? '查無預期未來庫存'}'),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              );
            }
          );
        },
      ),
    );
  }

  Future<void> _showFilterOption() async {
    final result = await Navigator.push<bool>(
      context, 
      MaterialPageRoute(
        builder: (context) => EditInventoryFilterPage(),
      )
    );

    if (result == true && mounted) {
      // 如果返回值為 true，表示篩選條件已經更新
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ 篩選條件已更新！'),
          duration: Duration(seconds: 2),
        ),
      );
      ref.invalidate(inventoryItemsProvider);
    }
  }

  Future<void> _openEditInventoryRequestPage({InventoryItem? inventoryItem}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditInventoryRequestPage(inventoryItem: inventoryItem,),
      ),
    );

    if (result == true && mounted) {
      // 如果返回值是 true，表示新增或編輯成功
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ 新增庫存請求成功！'),
          duration: Duration(seconds: 2),
        ),
      );
      // ref.invalidate(inventoryItemsProvider);
    }
  }
}
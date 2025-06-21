import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/export_order.dart';
import 'package:invenza/pages/home_page/edit_procurement_page.dart';
import 'package:invenza/pages/home_page/edit_sales_filter.dart';
import 'package:invenza/pages/home_page/edit_sales_page.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/providers/sales_provider.dart';
import 'package:invenza/widgets/text_form.dart';

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  @override
  void initState() {
    super.initState();
    // 可以在這裡初始化一些狀態或數據
  }

  @override
  Widget build(BuildContext context) {
    final asyncOrders = ref.watch(exportOrdersProvider);
    final api = ref.read(apiClientProvider);
    final user = ref.read(authProvider.notifier).user;
    final bool haveSalesPermission = ref.read(authProvider.notifier).haveSalerPermission();
    // 監聽刪除狀態，處理 UI
    ref.listen<AsyncValue<String?>>(deleteExportOrderProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ 刪除成功'), 
                duration: Duration(seconds: 2),
              ),
            );
            ref.invalidate(exportOrdersProvider); // 重新抓取資料
          }
        },
        loading: () {},
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ 刪除失敗: ${api.formatErrorMessage(error)}'),
              duration: const Duration(seconds: 5),
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('出貨列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterOptions,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(exportOrdersProvider),
          ),
        ],
      ),
      floatingActionButton: haveSalesPermission
          ? FloatingActionButton(
              onPressed: () => _openEditExportPage(ExportOrder(responsible: user), EditMode.add),
              tooltip: '新增出貨單',
              child: const Icon(Icons.add),
            )
          : null,
      body: asyncOrders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(api.formatErrorMessage(err))),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('目前沒有出貨訂單'));
          }
          // 如果有出貨訂單，顯示列表
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final responsible = order.responsible;

              // 只有有採購權限的使用者才顯示編輯和刪除按鈕，以及 user.id == responsible.id 才會顯示這些按鈕
              Widget trailing = haveSalesPermission && user != null && responsible != null && user.id == responsible.id
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _openEditExportPage(order, EditMode.edit),
                        icon: Icon(Icons.edit)
                      ),
                      IconButton(
                        onPressed: () => _deleteOrder(order),
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ],
                  )
                : SizedBox.shrink();

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
                  trailing: trailing,
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
                          const SizedBox(height: 4,),
                          Text('供應商: ${order.distributor?.name ?? '查無經銷商名稱'}'),
                          Text('供應商email: ${order.distributor?.association.email ?? '查無經銷商email'}'),
                          Text('供應商電話: ${order.distributor?.association.phone ?? '查無經銷商電話'}'),
                          const SizedBox(height: 4,),
                          Text('下單日期: ${ExportOrder.parseDateTime(order.orderTimeStamp) ?? '查無下單日期'}'),
                          Text('截止日期: ${ExportOrder.parseDateTime(order.deadlineTimeStamp) ?? '查無截止日期'}'),
                          const SizedBox(height: 4,),
                          Row(
                            children: [
                              responsibleText(
                                responsible: order.responsible,
                                context: context,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        
      ),
    );
  }

  Future<void> _openEditExportPage(ExportOrder order, EditMode mode) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditSalesPage(
          exportOrder: order,
          editMode: mode,
        ),
      ),
    );

    // 如果返回值是 true，表示需要刷新資料
    if (result == true && mounted) {
      final message = mode == EditMode.add ? '✅ 新增成功！' : '✅ 修改成功！';
      // 顯示 Snackbar 提示新增或修改成功
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
        ),
      );
      ref.invalidate(exportOrdersProvider); // 觸發 Riverpod 重新抓資料
    }
  }

  Future<void> _showFilterOptions() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditSalesFilter(),
      ),
    );

    if (result == true && mounted) {
      // 如果返回值是 true，表示篩選條件已更新
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ 篩選條件已更新！'),
          duration: Duration(seconds: 2),
        ),
      );
      ref.invalidate(exportOrdersProvider); // 重新抓取資料
    }
  }

  Future<void> _deleteOrder(ExportOrder order) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('刪除出貨單'),
        content: Text('確定要刪除這個出貨單嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('刪除'),
          ),
        ],
      ),
    );

    // 如果返回值是 true，表示需要刪除資料
    if (result == true && mounted) {
      await ref.read(deleteExportOrderProvider.notifier).deleteOrder(order);
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/import_order.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/widgets/text_form.dart';

import '../../providers/auth_provider.dart';
import '../../providers/procurement_provider.dart';
import 'edit_procurement_page.dart';

class ProcurementPage extends ConsumerStatefulWidget {
  const ProcurementPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProcurementPageState();
}

class _ProcurementPageState extends ConsumerState<ProcurementPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncOrders = ref.watch(importOrdersProvider);
    final api = ref.read(apiClientProvider);
    final user = ref.read(userProvider);

    // 監聽刪除狀態，處理 UI
    ref.listen<AsyncValue<String?>> (
      deleteImportOrderProvider,
          (prev, next) {
        next.when(
              data: (result) {
            if (result == 'success' && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ 刪除成功'),
                  duration: Duration(seconds: 2),  
                ),
              );
              ref.invalidate(importOrdersProvider); // 刷新資料
            }
          },
          loading: () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('⌛ 正在刪除中...'),
                  duration: Duration(seconds: 2),
              ),
              );
            }
          },
          error: (e, _) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('❌ 刪除失敗：${api.formatErrorMessage(e)}'),
                  duration: Duration(seconds: 5),
                ),
              );
            }
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('進貨列表'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditProcurementPage(ImportOrder(responsible: user), EditMode.add),
        tooltip: '新增進貨單',
        child: const Icon(Icons.add),
      ),
      body: asyncOrders.when(
        loading: () => Center(child: CircularProgressIndicator(),),
        error: (err, _) => Center(child: Text(api.formatErrorMessage(err)),),
        data: (orders) {
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final responsible = order.responsible;
              Widget? trailing;
              if (user != null && responsible != null && user.id == responsible.id) {
                trailing = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () => _openEditProcurementPage(order, EditMode.edit),
                        icon: Icon(Icons.edit)
                    ),
                    IconButton(
                      onPressed: () => _deleteOrder(order),
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                );
              } else {
                trailing = SizedBox.shrink();
              }


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
                          Text('供應商: ${order.supplier?.name ?? '查無供應商名稱'}'),
                          Text('供應商email: ${order.supplier?.association.email ?? '查無供應商email'}'),
                          Text('供應商電話: ${order.supplier?.association.phone ?? '查無供應商電話'}'),
                          const SizedBox(height: 4,),
                          Text('下單日期: ${ImportOrder.parseDateTime(order.orderTimeStamp) ?? '查無下單日期'}'),
                          Text('截止日期: ${ImportOrder.parseDateTime(order.deadlineTimeStamp) ?? '查無截止日期'}'),
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
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openEditProcurementPage(ImportOrder order, EditMode mode) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProcurementPage(importOrder: order, editMode: mode,),
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
      ref.invalidate(importOrdersProvider); // 觸發 Riverpod 重新抓資料
    }
  }

  Future<void> _deleteOrder(ImportOrder order) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('刪除進貨單'),
        content: Text('確定要刪除這個進貨單嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(true); // 關閉對話框並返回 true
            },
            child: Text('刪除'),
          ),
        ],
      ),
    );

    if (result == true && mounted){
      await ref.read(deleteImportOrderProvider.notifier).deleteOrder(order);
      // 不要在這裡再 show Snackbar 或 listen，統一交給 build 裡的 ref.listen 處理
    }
  }

}
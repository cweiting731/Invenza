import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/inventory_item.dart';
import 'package:invenza/models/transfer_data/inventory_request.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/providers/dashboard_provider.dart';
import 'package:invenza/widgets/text_form.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  void initState() {
    super.initState();
    ref.read(dashboardProvider.notifier).fetchAllData(); // 第一次自動載入
    ref.listenManual<DashboardState>(
      dashboardProvider,
      (previous, next) {
        if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
          // 用 WidgetsBinding 安全觸發 Snackbar
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(next.errorMessage!)),
            );

          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final hasProcurementPermission = ref.read(authProvider.notifier).haveProcurementPermission();
    final hasSalesPermission = ref.read(authProvider.notifier).haveSalerPermission();
    final hasInventoryPermission = ref.read(authProvider.notifier).haveInventoryPermission();

    return Scaffold(
      appBar: AppBar(
        title: const Text('主頁'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(dashboardProvider.notifier).fetchAllData();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 不對純inventory開放 "已接受的請求區域"
              if (hasInventoryPermission && !hasProcurementPermission && !hasSalesPermission)
                const SizedBox.shrink()
              else if (state.userRequests == null)
                const CircularProgressIndicator()
              else
                _buildRequestSection('已接受的請求', state.userRequests!, true, isUserRequest: true),

              if (state.procurementData == null)
                const CircularProgressIndicator()
              else
                _buildRequestSection('採購請求', state.procurementData!, hasProcurementPermission),

              if (state.salesData == null)
                const CircularProgressIndicator()
              else
                _buildRequestSection('銷售請求', state.salesData!, hasSalesPermission),

              if (state.inventoryData == null)
                const CircularProgressIndicator()
              else
                _buildInventorySection(state.inventoryData!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestSection(String title, List<InventoryRequest> items, bool havePermission, {bool isUserRequest = false}) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      children: items.isEmpty
        ? [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('目前暫無$title', style: const TextStyle(color: Colors.grey)),
            ),
          ]
        : items.map((item) {

            Widget? trailing;
            // 根據權限和請求類型決定尾部按鈕
            if (havePermission && !isUserRequest) { // 採購請求與銷售請求 (承接請求)
              trailing = IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  if (await checkUserActionDialog(context, '確認承接請求', '你確定要承接這個請求嗎？')) {
                    try {
                      await ref.read(dashboardProvider.notifier).acceptRequest(item);
                      _showMessageSnackbar('已成功承接請求: ${item.commodity.name}');
                    } catch (e) {
                      _showMessageSnackbar(ref.read(apiClientProvider).formatErrorMessage(e));
                    }
                  }
                },
              );
            } else if (havePermission && isUserRequest) { // 使用者已接受的請求 (放棄與完成請求)      
              trailing = Wrap(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      if (await checkUserActionDialog(context, '確認放棄請求', '你確定要放棄這個請求嗎？')) {
                        try {
                          await ref.read(dashboardProvider.notifier).abandonRequest(item);
                          _showMessageSnackbar('已成功放棄請求: ${item.commodity.name}');
                        } catch (e) {
                          _showMessageSnackbar(ref.read(apiClientProvider).formatErrorMessage(e));
                        }
                      }
                    },
                  ), 
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () async {
                      if (await checkUserActionDialog(context, '確認完成請求', '你確定完成了這個請求了嗎？')) {
                        try {
                          await ref.read(dashboardProvider.notifier).finishedRequest(item);
                          _showMessageSnackbar('已確認完成請求: ${item.commodity.name}');
                        } catch (e) {
                          _showMessageSnackbar(ref.read(apiClientProvider).formatErrorMessage(e));
                        }
                      }
                    },
                  )
                ],
              );
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: Text('${item.commodity.name} / ${item.commodity.type}'),
                  trailing: trailing,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      Text('請求數量: ${item.requestQuantity}'),
                      responsibleText(context: context, responsible: item.responsible, label: '請求人'),
                    ],
                  ),
                ),
              ),
            );
          }).toList()

    );
  }


  Widget _buildInventorySection(List<InventoryItem> items) {
    return ExpansionTile(
      title: const Text('庫存 見底/爆倉 項目', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      children: items.isEmpty
          ? [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('目前暫無庫存資料', style: TextStyle(color: Colors.grey)),
              ),
            ]
          : items.map((item) => Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: Text('${item.commodity?.name ?? '查無庫存商品名稱'} / ${item.commodity?.type ?? '查無庫存商品類型'}'),
                  subtitle: Wrap(
                    children: [
                      Text('庫存數量: ${item.stockQuantity}'),
                      const SizedBox(width: 8),
                      Text('未來庫存數量: ${item.futureStockQuantity}'),
                      const SizedBox(width: 8),
                      Text('預期進貨數量: ${item.expectedImportQuantity}'),
                      const SizedBox(width: 8),
                      Text('預期出貨數量: ${item.expectedExportQuantity}'),
                    ],
                  ),
                ),
              )
            )).toList(),
    );
  }

  Future<bool> checkUserActionDialog(BuildContext context, String title, String content) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  void _showMessageSnackbar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
}
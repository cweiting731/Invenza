import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/inventory_item.dart';
import 'package:invenza/models/transfer_data/inventory_request.dart';
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
        print('Dashboard state changed: $next');
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
              if (state.procurementData == null)
                const CircularProgressIndicator()
              else
                _buildRequestSection('採購請求', state.procurementData!),

              if (state.salesData == null)
                const CircularProgressIndicator()
              else
                _buildRequestSection('銷售請求', state.salesData!),

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

  Widget _buildRequestSection(String title, List<InventoryRequest> items) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      children: items.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('目前暫無$title', style: const TextStyle(color: Colors.grey)),
              ),
            ]
        : items.map((item) => Card(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                title: Text('${item.commodity.name} / ${item.commodity.type}'),
                subtitle: Row(
                  children: [
                    Text('請求數量: ${item.requestQuantity}'),
                    const SizedBox(width: 8),
                    responsibleText(context: context, responsible: item.responsible, label: '請求人'),
                  ],
                ),
              ),
            )
          )).toList(),
    );
  }


  Widget _buildInventorySection(List<InventoryItem> items) {
    return ExpansionTile(
      title: const Text('庫存見底/爆倉項目', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

}
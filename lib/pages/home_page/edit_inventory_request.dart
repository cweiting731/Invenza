import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/commodity.dart';
import 'package:invenza/models/inventory_item.dart';
import 'package:invenza/models/transfer_data/inventory_request.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/providers/inventory_provider.dart';
import 'package:invenza/widgets/text_form.dart';

class EditInventoryRequestPage extends ConsumerStatefulWidget {
  final InventoryItem? inventoryItem;

  const EditInventoryRequestPage({super.key, this.inventoryItem});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditInventoryRequestPageState();
}

class _EditInventoryRequestPageState extends ConsumerState<EditInventoryRequestPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final InventoryItem? _inventoryItem;
  final TextEditingController _commodityNameController = TextEditingController();
  final TextEditingController _commodityTypeController = TextEditingController();
  final TextEditingController _stockQuantityController = TextEditingController();
  final TextEditingController _futureStockQuantityController = TextEditingController();
  final TextEditingController _requestQuantityController = TextEditingController();
  RequestTarget? _selectedTarget;
  bool procurementOnly = false;

  // procurementOnly 為 true 時，表示只允許將 selectedTarget 發給 procurement 
  // 從右下角的新增請求按鈕進入，沒有傳入inventoryItem 
  // 不鎖定 commodityName 和 commodityType 的輸入框
  // 不顯示 stockQuantity 和 futureStockQuantity 的輸入框
  // 下拉式選單選擇 target，預設為 RequestTarget.procurement 並且不可更改

  // procurementOnly 為 false 時，表示可以選擇 saler 或 procurement
  // 長按進入，有傳入 inventoryItem 
  // 要鎖定 commodityName 和 commodityType 的輸入框
  // 顯示 stockQuantity 和 futureStockQuantity 的輸入框
  // 下拉式選單選擇 target，預設為 null，並且可以更改

  @override
  void initState() {
    super.initState();
    _inventoryItem = widget.inventoryItem;
    if (_inventoryItem == null) {
      procurementOnly = true;
    }

    _commodityNameController.text = _inventoryItem?.commodity?.name ?? '';
    _commodityTypeController.text = _inventoryItem?.commodity?.type ?? '';
    _stockQuantityController.text = _inventoryItem?.stockQuantity.toString() ?? '';
    _futureStockQuantityController.text = _inventoryItem?.futureStockQuantity.toString() ?? '';
    _requestQuantityController.text = '';
    _selectedTarget = procurementOnly ? RequestTarget.procurement : null;
  }

  @override
  void dispose() {
    // 清理資源
    _commodityNameController.dispose();
    _commodityTypeController.dispose();
    _stockQuantityController.dispose();
    _futureStockQuantityController.dispose();
    _requestQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final api = ref.read(apiClientProvider);

    if (user == null || user.jwtToken == null) {
      return AlertDialog(
        title: const Text('錯誤'),
        content: Center(
          child: Text('使用者資料丟失，請重新登入'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('確認')
          )
        ],
      );
    }

    final addState = ref.watch(addInventoryRequestProvider);
    Widget feedbackWidget = addState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // 在畫面渲染後顯示 SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(api.formatErrorMessage(e), style: TextStyle(color: Colors.red),),
              duration: Duration(seconds: 2),
            ),
          );
        });
        return Text(api.formatErrorMessage(e), style: TextStyle(color: Colors.red));
      },
      data: (data) {
        if (data == 'success') {
          // 如果是新增或編輯成功，則關閉頁面並返回 true 延遲pop
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop(true);
          });
        } 
        return const SizedBox.shrink();
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        title: const Text('編輯庫存請求'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                final request = InventoryRequest(
                  commodity: Commodity(_commodityNameController.text.trim(), _commodityTypeController.text.trim(), null),
                  requestQuantity: double.tryParse(_requestQuantityController.text) ?? 0,
                  target: _selectedTarget ?? RequestTarget.saler,
                  responsible: user,
                );
                await ref.read(addInventoryRequestProvider.notifier).addRequest(request);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                normalTextFormField(
                  controller: _commodityNameController, 
                  label: '商品名稱', 
                  icon: Icons.shopping_bag, 
                  readOnly: !procurementOnly,
                ),
                const SizedBox(height: 8),
                normalTextFormField(
                  controller: _commodityTypeController, 
                  label: '商品型號', 
                  icon: Icons.qr_code, 
                  readOnly: !procurementOnly,
                ),
                const SizedBox(height: 8),

                if (!procurementOnly) ...[
                  normalTextFormField(
                    controller: _stockQuantityController, 
                    label: '庫存數量', 
                    icon: Icons.storage, 
                    readOnly: true,
                  ),
                  const SizedBox(height: 8),
                  normalTextFormField(
                    controller: _futureStockQuantityController, 
                    label: '預期未來庫存', 
                    icon: Icons.trending_up, 
                    readOnly: true,
                  ),
                  const SizedBox(height: 8),
                ],
                
                TextFormField(
                  controller: _requestQuantityController,
                  decoration: InputDecoration(
                    labelText: '申請數量',
                    prefixIcon: Icon(Icons.add_circle_outline),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入申請數量';
                    }
                    final quantity = double.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return '請輸入有效的申請數量';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<RequestTarget>(
                  value: _selectedTarget,
                  items: RequestTarget.values.map((target) {
                    return DropdownMenuItem(
                      value: target,
                      child: Text(target.displayName),
                    );
                  }).toList(),
                  onChanged: procurementOnly ? null : (value) {
                    setState(() {
                      _selectedTarget = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: '請求目標', 
                    prefixIcon: Icon(Icons.group_add),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return '請選擇請求目標';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    responsibleText(context: context, responsible: user),
                  ],
                ),
                const SizedBox(height: 16),
                feedbackWidget,
              ],
            )
          ),
        )
      )
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invenza/models/association.dart';
import 'package:invenza/models/business_partner.dart';
import 'package:invenza/models/commodity.dart';
import 'package:invenza/models/import_order.dart';
import 'package:invenza/models/transaction_value.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/providers/procurement_provider.dart';
import 'package:invenza/widgets/text_form.dart';

enum EditMode { add, edit }

class EditProcurementPage extends ConsumerStatefulWidget {
  final ImportOrder importOrder;
  final EditMode editMode;

  const EditProcurementPage({super.key, required this.importOrder, required this.editMode});

  @override
  ConsumerState<EditProcurementPage> createState() => _AddProcurementDialogState();
}

class _AddProcurementDialogState extends ConsumerState<EditProcurementPage> {
  final _formKey = GlobalKey<FormState>();
  final _commodityNameController = TextEditingController();
  final _commodityTypeController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _supplierNameController = TextEditingController();
  final _supplierIdController = TextEditingController();
  final _supplierEmailController = TextEditingController();
  final _supplierPhoneController = TextEditingController();
  final _orderTimeStampController = TextEditingController();
  final _deadlineTimeStampController = TextEditingController();
  late final ImportOrder order;
  late final EditMode editMode;
  bool isTransfer = false;

  @override
  void initState() {
    super.initState();
    order = widget.importOrder;
    editMode = widget.editMode;

    _commodityNameController.text = order.commodity?.name ?? '';
    _commodityTypeController.text = order.commodity?.type ?? '';
    _unitPriceController.text = order.commodity?.transactionValue?.unitPrice.toString() ?? '';
    _quantityController.text = order.commodity?.transactionValue?.quantity.toString() ?? '';
    _totalCostController.text = order.commodity?.transactionValue?.totalCost.toString() ?? '';
    _supplierNameController.text = order.supplier?.name ?? '';
    _supplierIdController.text = order.supplier?.id ?? '';
    _supplierEmailController.text = order.supplier?.association.email ?? '';
    _supplierPhoneController.text = order.supplier?.association.phone ?? '';
    _orderTimeStampController.text = ImportOrder.parseDateTime(order.orderTimeStamp) ?? '';
    _deadlineTimeStampController.text = ImportOrder.parseDateTime(order.deadlineTimeStamp) ?? '';
  }

  @override
  void dispose() {
    _commodityNameController.dispose();
    _commodityTypeController.dispose();
    _unitPriceController.dispose();
    _quantityController.dispose();
    _totalCostController.dispose();
    _supplierNameController.dispose();
    _supplierIdController.dispose();
    _supplierEmailController.dispose();
    _supplierPhoneController.dispose();
    _orderTimeStampController.dispose();
    _deadlineTimeStampController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final api = ref.read(apiClientProvider);
    final format = DateFormat('yyyy-MM-dd HH:mm');
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

    final AsyncValue<String?> addState = editMode == EditMode.add
    ? ref.watch(addImportOrderProvider)
    : ref.watch(editImportOrderProvider);

    Widget feedbackWidget = addState.when(
      loading: () { 
        return const Text('傳送中...');
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
    );


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        title: Text('${editMode == EditMode.add ? '新增' : '編輯'}進貨單'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final commodityName = _commodityNameController.text.trim();
                final commodityType = _commodityTypeController.text.trim();
                final unitPrice = double.parse(_unitPriceController.text.trim());
                final quantity = double.parse(_quantityController.text.trim());
                final totalCost = double.parse(_totalCostController.text.trim());
                final supplierName = _supplierNameController.text.trim();
                final supplierId = _supplierIdController.text.trim();
                final supplierEmail = _supplierEmailController.text.trim();
                final supplierPhone = _supplierPhoneController.text.trim();
                final orderTimeStamp = format.parseStrict(_orderTimeStampController.text.trim());
                final deadlineTimeStamp = format.parseStrict(_deadlineTimeStampController.text.trim());
                if (editMode == EditMode.add) {
                  await ref.read(addImportOrderProvider.notifier).addOrder(
                    ImportOrder(
                        commodity: Commodity(commodityName, commodityType, TransactionValue(unitPrice: unitPrice, quantity: quantity, totalCost: totalCost)),
                        supplier: BusinessPartner(supplierName, supplierId, Association(email: supplierEmail, phone: supplierPhone)),
                        orderTimeStamp: orderTimeStamp,
                        deadlineTimeStamp: deadlineTimeStamp,
                        responsible: order.responsible
                    ),
                  );
                } else {
                  await ref.read(editImportOrderProvider.notifier).editOrder(
                    ImportOrder(
                        id: order.id,
                        commodity: Commodity(commodityName, commodityType, TransactionValue(unitPrice: unitPrice, quantity: quantity, totalCost: totalCost)),
                        supplier: BusinessPartner(supplierName, supplierId, Association(email: supplierEmail, phone: supplierPhone)),
                        orderTimeStamp: orderTimeStamp,
                        deadlineTimeStamp: deadlineTimeStamp,
                        responsible: order.responsible
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView( // 加上避免 overflow
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (editMode == EditMode.edit)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('進貨單ID：${order.id}'),],
                  ),
                  const SizedBox(height: 12,),
                normalTextFormField(controller: _commodityNameController, label: '商品名稱', icon: Icons.shopping_bag),
                const SizedBox(height: 12,),
                normalTextFormField(controller: _commodityTypeController, label: '商品型號', icon: Icons.qr_code),
                const SizedBox(height: 12,),
                transactionValueTextFormField(
                  thisController: _unitPriceController, 
                  label: '單價', 
                  icon: Icons.attach_money, 
                  unitPriceController: _unitPriceController, 
                  quantityController: _quantityController, 
                  totalCostController: _totalCostController
                ),
                const SizedBox(height: 12,),
                transactionValueTextFormField(
                  thisController: _quantityController, 
                  label: '數量', 
                  icon: Icons.confirmation_number, 
                  unitPriceController: _unitPriceController, 
                  quantityController: _quantityController, 
                  totalCostController: _totalCostController
                ),
                const SizedBox(height: 12,),
                transactionValueTextFormField(
                  thisController: _totalCostController, 
                  label: '總價', 
                  icon: Icons.payments, 
                  unitPriceController: _unitPriceController, 
                  quantityController: _quantityController, 
                  totalCostController: _totalCostController
                ),
                const SizedBox(height: 12,),
                normalTextFormField(controller: _supplierNameController, label: '供應商名稱', icon: Icons.business),
                const SizedBox(height: 12,),
                normalTextFormField(controller: _supplierIdController, label: '供應商編號', icon: Icons.badge),
                const SizedBox(height: 12,),
                emailTextFormField(controller: _supplierEmailController, label: '供應商 Email'), 
                const SizedBox(height: 12,),
                TextFormField(
                  controller: _supplierPhoneController,
                  decoration: const InputDecoration(
                    labelText: '供應商電話',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                  value!.isEmpty ? '請輸入電話號碼' : null,
                ),
                const SizedBox(height: 12,),
                timeSelectedTextFormField(controller: _orderTimeStampController, label: '下單日期', context: context),
                const SizedBox(height: 12,),
                timeSelectedTextFormField(controller: _deadlineTimeStampController, label: '到貨日期', context: context),
                const SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    responsibleText(context: context, responsible: order.responsible),
                  ],
                ),
                const SizedBox(height: 12,),
                feedbackWidget
              ],
            ),
          ),
        )
      ),
    );
  }
}
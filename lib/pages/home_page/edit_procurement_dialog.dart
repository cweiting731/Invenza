import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invenza/models/association.dart';
import 'package:invenza/models/business_partner.dart';
import 'package:invenza/models/commodity.dart';
import 'package:invenza/models/import_order.dart';
import 'package:invenza/models/transaction_value.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/providers/procurement_provider.dart';

enum EditMode { add, edit }

class EditProcurementPage extends ConsumerStatefulWidget {
  ImportOrder importOrder;
  EditMode editMode;

  EditProcurementPage({super.key, required this.importOrder, required this.editMode});

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

    final addState = ref.watch(addImportOrderProvider);
    final feedbackWidget = addState.maybeWhen(
      loading: () => const Text('傳送中...'),
      data: (data) {
        if (data != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop(true);
          });
        }
        return SizedBox.shrink();
      },
      error: (e, _) => Text(api.formatErrorMessage(e), style: TextStyle(color: Colors.red),),
      orElse: () => const SizedBox.shrink(),
    );
    // log.i('edit_procurement_page');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // 左側 icon，可改成你需要的
          onPressed: () {
            Navigator.of(context).pop(false); // 返回上一頁
          },
        ),
        title: const Text('新增進貨單'),
        centerTitle: true, // 可選：讓標題置中
        actions: [
          IconButton(
            icon: const Icon(Icons.check), // 右側 icon，可改成你需要的
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
                    FilterOptions());
                } else {

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
                    children: [Text('進貨單ID'),],
                  ),
                  const SizedBox(height: 4,),
                TextFormField(
                  controller: _commodityNameController,
                  decoration: const InputDecoration(
                    labelText: '商品名稱',
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                  validator: (value) => value!.isEmpty ? '請輸入商品名稱' : null,
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: _commodityTypeController,
                  decoration: const InputDecoration(
                    labelText: '商品型號',
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                  validator: (value) => value!.isEmpty ? '請輸入型號' : null,
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: _unitPriceController,
                  decoration: const InputDecoration(
                    labelText: '單價',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value!.isEmpty ? '請輸入單價' : null,
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: '數量',
                    prefixIcon: Icon(Icons.confirmation_number),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? '請輸入數量' : null,
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: _totalCostController,
                  decoration: const InputDecoration(
                    labelText: '總價',
                    prefixIcon: Icon(Icons.payments),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value!.isEmpty ? '請輸入總價' : null,
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: _supplierNameController,
                  decoration: const InputDecoration(
                    labelText: '供應商名稱',
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) => value!.isEmpty ? '請輸入供應商名稱' : null,
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: _supplierIdController,
                  decoration: const InputDecoration(
                    labelText: '供應商編號',
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: (value) => value!.isEmpty ? '請輸入供應商編號' : null,
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: _supplierEmailController,
                  decoration: const InputDecoration(
                    labelText: '供應商 Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value!.isEmpty ? '請輸入 Email' : null,
                ),
                const SizedBox(height: 4,),
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
                const SizedBox(height: 4,),
                TextFormField(
                  controller: _orderTimeStampController,
                  decoration: const InputDecoration(
                    labelText: '下單日期',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2030),
                    );
                    if (date == null) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time == null) return;
                    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                    _orderTimeStampController.text = format.format(dateTime);
                  },
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: _deadlineTimeStampController,
                  decoration: const InputDecoration(
                    labelText: '到貨日期',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2030),
                    );
                    if (date == null) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time == null) return;
                    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                    _deadlineTimeStampController.text = format.format(dateTime);
                  },
                ),
                const SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('負責人: ${order.responsible?.name}'),
                  ],
                ),
                const SizedBox(height: 4,),
                feedbackWidget
              ],
            ),
          ),
        )
      ),
    );
  }
}
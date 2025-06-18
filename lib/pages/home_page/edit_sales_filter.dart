import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/providers/sales_provider.dart';
import 'package:invenza/widgets/text_form.dart';

class EditSalesFilter extends ConsumerStatefulWidget {
  const EditSalesFilter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditSalesFilterState();
}

class _EditSalesFilterState extends ConsumerState<EditSalesFilter> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commodityNameController = TextEditingController();
  final TextEditingController _commodityTypeController = TextEditingController();
  final TextEditingController _distributorController = TextEditingController();
  final TextEditingController _distributorIdController = TextEditingController();
  final TextEditingController _orderTimeStartController = TextEditingController();
  final TextEditingController _orderTimeEndController = TextEditingController();
  final TextEditingController _deadlineStartController = TextEditingController();
  final TextEditingController _deadlineEndController = TextEditingController();
  final TextEditingController _responsibleController = TextEditingController();
  final TextEditingController _responsibleIdController = TextEditingController();
  final format = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
    final filters = ref.read(exportOrderFilterProvider);
    _commodityNameController.text = filters.commodityName ?? '';
    _commodityTypeController.text = filters.commodityType ?? '';
    _distributorController.text = filters.businessPartner ?? '';
    _distributorIdController.text = filters.businessPartnerId ?? '';
    _orderTimeStartController.text = filters.orderTimeStart != null ? format.format(filters.orderTimeStart!) : '';
    _orderTimeEndController.text = filters.orderTimeEnd != null ? format.format(filters.orderTimeEnd!) : '';
    _deadlineStartController.text = filters.deadlineStart != null ? format.format(filters.deadlineStart!) : '';
    _deadlineEndController.text = filters.deadlineEnd != null ? format.format(filters.deadlineEnd!) : '';
    _responsibleController.text = filters.responsible ?? '';
    _responsibleIdController.text = filters.responsibleId ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _commodityNameController.dispose();
    _commodityTypeController.dispose();
    _distributorController.dispose();
    _distributorIdController.dispose();
    _orderTimeStartController.dispose();
    _orderTimeEndController.dispose();
    _deadlineStartController.dispose();
    _deadlineEndController.dispose();
    _responsibleController.dispose();
    _responsibleIdController.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false)
        ),
        title: const Text('編輯採購篩選條件'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // 提交篩選條件
              final filters = FilterOptions(
                commodityName: _commodityNameController.text.isNotEmpty ? _commodityNameController.text : null,
                commodityType: _commodityTypeController.text.isNotEmpty ? _commodityTypeController.text : null,
                businessPartner: _distributorController.text.isNotEmpty ? _distributorController.text : null,
                businessPartnerId: _distributorIdController.text.isNotEmpty ? _distributorIdController.text : null,
                orderTimeStart: _orderTimeStartController.text.isNotEmpty ? format.parseStrict(_orderTimeStartController.text) : null,
                orderTimeEnd: _orderTimeEndController.text.isNotEmpty ? format.parseStrict(_orderTimeEndController.text) : null,
                deadlineStart: _deadlineStartController.text.isNotEmpty ? format.parseStrict(_deadlineStartController.text) : null,
                deadlineEnd: _deadlineEndController.text.isNotEmpty ? format.parseStrict(_deadlineEndController.text) : null,
                responsible: _responsibleController.text.isNotEmpty ? _responsibleController.text : null,
                responsibleId: _responsibleIdController.text.isNotEmpty ? _responsibleIdController.text : null,
              );
              // 更新篩選條件
              ref.read(exportOrderFilterProvider.notifier).state = filters;
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                normalTextFormFieldWithoutValidator(
                  controller: _commodityNameController, 
                  label: '商品名稱', 
                  icon: Icons.shopping_bag
                ),
                const SizedBox(height: 8),
                normalTextFormFieldWithoutValidator(
                  controller: _commodityTypeController, 
                  label: '商品類型', 
                  icon: Icons.category
                ),
                const SizedBox(height: 8),
                normalTextFormFieldWithoutValidator(
                  controller: _distributorController, 
                  label: '經銷商', 
                  icon: Icons.business
                ),
                const SizedBox(height: 8),
                normalTextFormFieldWithoutValidator(
                  controller: _distributorIdController, 
                  label: '經銷商ID', 
                  icon: Icons.business_center
                ),
                const SizedBox(height: 8),
                timeSelectedTextFormField(
                  controller: _orderTimeStartController,
                  label: '訂單開始時間',
                  context: context
                ),
                const SizedBox(height: 8),
                timeSelectedTextFormField(
                  controller: _orderTimeEndController,
                  label: '訂單結束時間',
                  context: context
                ),
                const SizedBox(height: 8),
                timeSelectedTextFormField(
                  controller: _deadlineStartController,
                  label: '截止開始時間',
                  context: context
                ),
                const SizedBox(height: 8),
                timeSelectedTextFormField(
                  controller: _deadlineEndController,
                  label: '截止結束時間',
                  context: context
                ),
                const SizedBox(height: 8),
                normalTextFormFieldWithoutValidator(
                  controller: _responsibleController, 
                  label: '負責人姓名', 
                  icon: Icons.person
                ),
                const SizedBox(height: 8),
                normalTextFormFieldWithoutValidator(
                  controller: _responsibleIdController, 
                  label: '負責人ID', 
                  icon: Icons.person_outline
                ),
              ],
            )
          ),
        ),
      )
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/providers/inventory_provider.dart';
import 'package:invenza/widgets/text_form.dart';

class EditInventoryFilterPage extends ConsumerStatefulWidget {
  const EditInventoryFilterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditInventoryFilterState();
}

class _EditInventoryFilterState extends ConsumerState<EditInventoryFilterPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commodityNameController = TextEditingController();
  final TextEditingController _commodityTypeController = TextEditingController();

  
  final TextEditingController _minAmountController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();

  InventoryFilterType? _selectedType;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(inventoryFilterProvider);
    _commodityNameController.text = filter.commodityName ?? '';
    _commodityTypeController.text = filter.commodityType ?? '';
    _minAmountController.text = filter.minAmount?.toString() ?? '';
    _maxAmountController.text = filter.maxAmount?.toString() ?? '';
    _selectedType = filter.inventoryFilterType;
  }

  @override
  void dispose() {
    _commodityNameController.dispose();
    _commodityTypeController.dispose();
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop()
        ),
        title: const Text('編輯庫存篩選條件'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final filter = FilterOptions(
                commodityName: _commodityNameController.text.isNotEmpty ? _commodityNameController.text : null,
                commodityType: _commodityTypeController.text.isNotEmpty ? _commodityTypeController.text : null,
                minAmount: _minAmountController.text.isNotEmpty ? double.tryParse(_minAmountController.text) : null,
                maxAmount: _maxAmountController.text.isNotEmpty ? double.tryParse(_maxAmountController.text) : null,
                inventoryFilterType: _selectedType,
              );
              ref.read(inventoryFilterProvider.notifier).state = filter;
              Navigator.of(context).pop(true);
            }, 
          )
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
                DropdownButtonFormField<InventoryFilterType>(
                  value: _selectedType,
                  items: InventoryFilterType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: '庫存篩選類型'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _minAmountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: '最小庫存數量'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _maxAmountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: '最大庫存數量'),
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}
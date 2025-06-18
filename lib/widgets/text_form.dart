import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/models/transaction_value.dart';

Widget responsibleText({
  Employee? responsible,
  required BuildContext context,
}) {
  return TextButton(
    onPressed: () {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text('負責人資訊'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('姓名: ${responsible?.name ?? '查無負責人姓名'}'),
              const SizedBox(height: 8,),
              Text('ID: ${responsible?.id ?? '查無負責人ID'}\n'),
              const SizedBox(height: 8,),
              Text('email: ${responsible?.association.email ?? '查無負責人email'}\n'),
              const SizedBox(height: 8,),
              Text('電話: ${responsible?.association.phone ?? '查無負責人電話'}\n'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('關閉'),
            ),
          ],
        ),
      );
    }, 
    child: Text('負責人: ${responsible?.name}'),
  );
}

Widget timeSelectedTextFormField({
  required TextEditingController controller,
  required String label,
  required BuildContext context
}) {
  final format = DateFormat('yyyy-MM-dd HH:mm');
  return TextFormField(
    controller: controller,
    readOnly: true,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: const Icon(Icons.calendar_today),
    ),
    onTap: () async {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date == null) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time == null) return;
      final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      controller.text = format.format(dateTime);
    },
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '請選擇時間';
      }
      try {
        format.parseStrict(value);
      } catch (_) {
        return '時間格式錯誤，請使用 yyyy-MM-dd HH:mm 格式';
      }
      return null;
    },
  );
}

Widget normalTextFormField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  String? Function(String?)? validator,
  bool readOnly = false,
}) {
  return TextFormField(
    controller: controller,
    readOnly: readOnly,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
    ),
    validator: validator ?? (value) {
      if (value == null || value.isEmpty) {
        return '請輸入 $label';
      }
      return null;
    },
  );
}

Widget normalTextFormFieldWithoutValidator({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool readOnly = false,
}) {
  return TextFormField(
    controller: controller,
    readOnly: readOnly,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
    ),
  );
}

Widget emailTextFormField({
  required TextEditingController controller,
  required String label,
  String? hintText,
  IconData? icon,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: icon != null ? Icon(icon) : const Icon(Icons.email),
    ),
    keyboardType: TextInputType.emailAddress,
    validator: validator ?? (value) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (value == null || value.isEmpty) {
        return '$label 不能為空';
      }
      if (!emailRegex.hasMatch(value)) {
        return '$label 格式錯誤';
      }
      return null;
    },
  );
}

Widget transactionValueTextFormField({
  required TextEditingController thisController,
  required String label,
  required IconData icon,
  required TextEditingController unitPriceController,
  required TextEditingController quantityController,
  required TextEditingController totalCostController,
}) {
  return TextFormField(
    controller: thisController, 
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
    ),
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    textInputAction: TextInputAction.done,
    onFieldSubmitted: (_) {
      double? unitPrice = double.tryParse(unitPriceController.text.trim());
      double? quantity = double.tryParse(quantityController.text.trim());
      double? totalCost = double.tryParse(totalCostController.text.trim());
      TransactionValue? newPrice = TransactionValue.autoFill(unitPrice: unitPrice, quantity: quantity, totalCost: totalCost);
      if (newPrice != null) {
        unitPriceController.text = newPrice.unitPrice.toString();
        quantityController.text = newPrice.quantity.toString();
        totalCostController.text = newPrice.totalCost.toString();
      }
    },
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '請輸入 $label';
      }
      final parsedValue = double.tryParse(value);
      if (parsedValue == null || parsedValue < 0) {
        return '請輸入有效的 $label';
      }
      return null;
    },
  );
}  

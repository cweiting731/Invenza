import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invenza/models/employee.dart';

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
}) {
  return TextFormField(
    controller: controller,
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
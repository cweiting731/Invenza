import 'package:flutter/material.dart';
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
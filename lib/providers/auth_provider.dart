import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:invenza/models/association.dart';
import 'package:invenza/models/auth_data.dart';
import 'package:invenza/models/condition.dart';
import 'package:invenza/models/employee.dart';

final authProvider = StateNotifierProvider<AuthController, AsyncValue<Employee?>>(
    (ref) => AuthController(),
);

class AuthController extends StateNotifier<AsyncValue<Employee?>> {
  AuthController() : super(const AsyncValue.data(null));

  Future<void> login(String account, String password, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return; // 確認account, password格式是否正確

    state = const AsyncValue.loading(); // 設定狀態為loading
    
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/login'),
        headers: {'Content-Type': 'application/json'},
        body: Condition(
            'Login', AuthData(account, password).serialization_json()
            ).serialization(),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        if (data['name'] == null || data['id'] == null || (data['email'] == null && data['phone'] == null)) {
          throw Exception('員工資料缺失，請重新登入或聯繫相關人員');
        }
        Employee employee = Employee(data['name'], data['id'], Association(data['email'], data['phone']));
        // print(employee.getName());
        // print(employee.getID());
        // print(employee.getAssociation());
        state = AsyncValue.data(employee); // 表示成功
      } else {
        throw Exception(data['message'] ?? '登入失敗');
      }
    }
    on SocketException catch (e, st){
      state = AsyncValue.error(Exception('無法連接伺服器，請檢查網路連線'), st);
    }
    on FormatException catch (e, st) {
      state = AsyncValue.error(Exception('資料格式錯誤，請聯繫開發人員'), st);
    }
    on http.ClientException catch (e, st) {
      state = AsyncValue.error(Exception('連線失敗，請確認伺服器是否有開啟'), st);
    }
    catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
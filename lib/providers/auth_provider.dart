import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:invenza/models/association.dart';
import 'package:invenza/models/auth_data.dart';
import 'package:invenza/models/condition.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/log_provider.dart';
import 'package:invenza/services/api_client.dart';

import '../services/log_service.dart';

final authProvider = StateNotifierProvider<AuthController, AsyncValue<Employee?>>(
  (ref) {
    final logger = ref.read(logProvider);
    final api = ref.read(apiClientProvider);
    return AuthController(logger, api);
  }
);

class AuthController extends StateNotifier<AsyncValue<Employee?>> {
  final LogService _logger;
  final ApiClient _api;

  AuthController(this._logger, this._api)
      : super(const AsyncValue.data(null));

  Future<void> login(String account, String password, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return; // 確認account, password格式是否正確

    state = const AsyncValue.loading(); // 設定狀態為loading

    try {
      final data = await _api.post(
        'http://localhost:8080/api/login',
        Condition(
          'Login',
          AuthData(account, password).serialization_json()
        )
      );
      if (data['success'] == true) {
        if (data['name'] == null || data['id'] == null || (data['email'] == null && data['phone'] == null)) {
          throw Exception('員工資料缺失，請重新登入或聯繫相關人員');
        }
        Employee employee = Employee(data['name'], data['id'], Association(data['email'], data['phone']));
        // print(employee.getName());
        // print(employee.getID());
        // print(employee.getAssociation());
        state = AsyncValue.data(employee); // 表示成功
      }
    }
    catch (e, st) {
      print(e.toString());
      state = AsyncValue.error(e, st);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
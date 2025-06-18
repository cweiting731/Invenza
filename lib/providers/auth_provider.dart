import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/association.dart';
import 'package:invenza/models/transfer_data/auth_data.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/api_route.dart';
import 'package:invenza/providers/log_provider.dart';
import 'package:invenza/services/api_client.dart';

import '../services/log_service.dart';

final userProvider = Provider<Employee?>( (ref) {
  return ref.read(authProvider).maybeWhen(
    data: (e) => e,
    orElse: () => null,
  );
});

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

    // test mode
    if (account == 'admin' && password == 'admin1') {
      state = AsyncValue.data(Employee('admin', '110001', Association(email: 'admin@gmail.com', phone: '0912345678'), jwtToken: '11111'));
      return;
    }

    try {
      final data = await _api.post(
        ApiRoute.getRoute('auth'),
        AuthData(account, password),
      );

      if (data['name'] == null || data['id'] == null || (data['email'] == null && data['phone'] == null) || data['jwt'] == null) {
        _logger.error('employee data lost');
        throw Exception('員工資料缺失，請重新登入或聯繫相關人員');
      }
      Employee employee = Employee(data['name'], data['id'], Association(email: data['email'], phone: data['phone']), jwtToken: data['jwt']);
      state = AsyncValue.data(employee); // 表示成功
    }
    catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  bool haveProcurementPermission() {
    final user = state.value;
    if (user == null) return false; // 未登入
    // 取user.id最前面一位char，如果是F或是4則表示有採購權限
    final firstChar = user.id.isNotEmpty ? user.id[0].toUpperCase() : '';
    if (firstChar == 'F' || firstChar == '4') {
      return true; // 有採購權限
    }
    return false; // 沒有採購權限
  }

  bool haveInventoryPermission() {
    final user = state.value;
    if (user == null) return false; // 未登入
    // 取user.id最前面一位char，如果是F或是2則表示有庫存權限
    final firstChar = user.id.isNotEmpty ? user.id[0].toUpperCase() : '';
    if (firstChar == 'F' || firstChar == '2') {
      return true; // 有庫存權限
    }
    return false; // 沒有庫存權限
  }

  bool haveSalerPermission() {
    final user = state.value;
    if (user == null) return false; // 未登入
    // 取user.id最前面一位char，如果是F或是1則表示有銷售權限
    final firstChar = user.id.isNotEmpty ? user.id[0].toUpperCase() : '';
    if (firstChar == 'F' || firstChar == '1') {
      return true; // 有銷售權限
    }
    return false; // 沒有銷售權限
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
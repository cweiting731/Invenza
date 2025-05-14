import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:invenza/models/condition.dart';

final forgotPasswordProvider = StateNotifierProvider<ForgotPasswordController, AsyncValue<String>>(
      (ref) => ForgotPasswordController(),
);

class ForgotPasswordController extends StateNotifier<AsyncValue<String>> {
  ForgotPasswordController() : super(const AsyncValue.data(''));

  Future<void> submit(String email, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    state = const AsyncValue.loading();
    print('submit');
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: Condition(
          'ForgotPassword',
          {'email' : email,}
        ).serialization(),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        state = const AsyncValue.data('email傳送成功，請查看您的信箱確認');
        print('submit success');
      } else {
        throw Exception('查無email資訊');
      }
    }
    on SocketException catch (e, st) {
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
    state = const AsyncValue.data('');
  }
}

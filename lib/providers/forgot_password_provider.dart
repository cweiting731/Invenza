import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:invenza/models/transfer_data/forgot_password_data.dart';
import 'package:invenza/providers/api_route.dart';
import 'package:invenza/services/api_client.dart';

import '../services/log_service.dart';
import 'api_provider.dart';
import 'log_provider.dart';

final forgotPasswordProvider = StateNotifierProvider.autoDispose<ForgotPasswordController, AsyncValue<String?>>(
  (ref) {
    final logger = ref.read(logProvider);
    final api = ref.read(apiClientProvider);
    return ForgotPasswordController(logger, api);
  }
);

class ForgotPasswordController extends StateNotifier<AsyncValue<String?>> {
  final LogService _logger;
  final ApiClient _api;

  ForgotPasswordController(this._logger, this._api) : super(const AsyncValue.data(null));

  Future<void> submit(String email, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    state = const AsyncValue.loading();

    // test case
    if (email == 'admin@gmail.com') {
      state = const AsyncData('test success');
      return;
    }

    try {
      final data = await _api.post(
        ApiRoute.getRoute('forgot-password'),
        ForgotPasswordData(email),
      );

      state = const AsyncValue.data('email傳送成功，請查看您的信箱確認');
    }
    catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void reset() {
    state = const AsyncValue.data('');
  }
}

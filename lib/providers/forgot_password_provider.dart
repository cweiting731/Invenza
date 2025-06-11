import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/transfer_data/forgot_password_data.dart';
import 'package:invenza/providers/api_route.dart';
import 'package:invenza/services/api_client.dart';
import 'api_provider.dart';

final forgotPasswordProvider = StateNotifierProvider.autoDispose<ForgotPasswordController, AsyncValue<String?>>(
  (ref) {
    final api = ref.read(apiClientProvider);
    return ForgotPasswordController(api);
  }
);

class ForgotPasswordController extends StateNotifier<AsyncValue<String?>> {
  final ApiClient _api;

  ForgotPasswordController(this._api) : super(const AsyncValue.data(null));

  Future<void> submit(String email, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    state = const AsyncValue.loading();

    // test case
    if (email == 'admin@gmail.com') {
      state = const AsyncData('test success');
      return;
    }

    try {
      await _api.post(
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/forgot_password_provider.dart';

class ForgotPasswordBottomSheet extends ConsumerStatefulWidget {
  const ForgotPasswordBottomSheet({super.key});

  @override
  ConsumerState<ForgotPasswordBottomSheet> createState() => _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends ConsumerState<ForgotPasswordBottomSheet> {
  final emailController = TextEditingController();
  final forgotPasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordProvider);
    final api = ref.read(apiClientProvider);

    String? info;
    Color infoColor = Colors.black87;

    if (forgotState.isLoading) {
      info = '傳送中...';
    } else if (forgotState.hasError) {
      info = api.formatErrorMessage(forgotState.error);
      infoColor = Colors.red;
    } else if (forgotState.hasValue && forgotState.value != '') {
      info = forgotState.value;
      infoColor = Colors.green;
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: forgotPasswordFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(children: [Text('忘記密碼')]),
            const SizedBox(height: 24),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: '請輸入註冊時使用的email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (value == null || value.isEmpty) return 'email不能為空';
                if (!emailRegex.hasMatch(value)) return 'email格式錯誤';
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                await ref.read(forgotPasswordProvider.notifier).submit(email, forgotPasswordFormKey);
              },
              child: const Text('送出'),
            ),
            if (info != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(info!, style: TextStyle(color: infoColor)),
              )
          ],
        ),
      ),
    );
  }
}

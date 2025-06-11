import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/forgot_password_provider.dart';
import 'package:invenza/providers/log_provider.dart';

void showForgotPasswordBottomSheet(final context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius
            .circular(16))
    ),
    builder: (context) => const ForgotPasswordBottomSheet(),
  );
}

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
    final api = ref.read(apiClientProvider);

    String? info;
    Color infoColor = Colors.black87;
    bool isTransfer = false;

    ref.listen<AsyncValue<String?>>(forgotPasswordProvider, (previous, next) {
      next.when(
          data: (message) {
            ref.read(logProvider).info('forgot password: email transfer successfully');
            setState(() {
              info = message;
              infoColor = Colors.green;
              isTransfer = true;
            });
          },
          error: (e, _) {
            ref.read(logProvider).error('forgot password: $e');
            setState(() {
              info = api.formatErrorMessage(e);
              infoColor = Colors.red;
            });
          },
          loading: () {
            setState(() {
              info = '傳送中...';
              infoColor = Colors.black87;
            });
          }
      );
    });

    // if (forgotState.isLoading) {
    //   info = '傳送中...';
    // } else if (forgotState.hasError) {
    //   logger.error('forgot password: ${forgotState.error}');
    //   info = api.formatErrorMessage(forgotState.error);
    //   infoColor = Colors.red;
    // } else if (forgotState.hasValue && forgotState.value != '') {
    //   logger.info('forgot password: email transfer successfully');
    //   info = forgotState.value;
    //   infoColor = Colors.green;
    // }

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
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: (value) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (value == null || value.isEmpty) return 'email不能為空';
                if (!emailRegex.hasMatch(value)) return 'email格式錯誤';
                return null;
              },
            ),
            const SizedBox(height: 16),
            if (!isTransfer)
              ElevatedButton(
                onPressed: () => _submit(),
                child: const Text('送出'),
              ),
            if(isTransfer)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('確認'),
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

  void _submit() async {
    final email = emailController.text.trim();
    ref.read(logProvider).info('forgot password: transfer button is pressed. $email');
    await ref.read(forgotPasswordProvider.notifier).submit(email, forgotPasswordFormKey);
  }
}

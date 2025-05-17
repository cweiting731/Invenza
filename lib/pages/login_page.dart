import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/association.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/services/api_client.dart';
import 'package:invenza/theme/theme.dart';
import 'package:invenza/widgets/dialog_utils.dart';

import '../providers/auth_provider.dart';
import '../providers/forgot_password_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final api = ref.read(apiClientProvider);
    // 偵測auth_provider狀態，來切換頁面與顯示錯誤訊息
    ref.listen<AsyncValue<Employee?>>(authProvider, (prev, next) {
      next.when(
        loading: () {
          DialogUtils.showLoading(context, '登入中', message: '請稍後...');
        },
        data: (_) {
          // 登入成功 -> home page
          DialogUtils.dismiss(context);
          Navigator.pushReplacementNamed(context, '/home');
        },
        error: (err, _) {
          // 顯示錯誤
          DialogUtils.dismiss(context);
          setState(() => _errorMessage = api.formatErrorMessage(err));
        },
      );
    });

    print('build login page');

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 👉 主動取消目前的輸入焦點（keyboard收起來）
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.insert_emoticon_sharp),
          actions: [
            Builder(builder: (context) {
              return PopupMenuButton<String>(
                tooltip: '設定',
                icon: Icon(Icons.settings),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'problem', child: Text('問題回報')),
                  const PopupMenuItem(value: 'logout', child: Text('登出')),
                ],
              );
            }),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;
                  double contentWidth = screenWidth > 700
                      ? 600 // 大螢幕
                      : screenWidth * 0.85; // 小螢幕
                  double screenHeight = constraints.maxHeight;
                  double contentHeight = screenHeight > 600
                      ? 500
                      : screenHeight * 0.85;

                  return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: contentWidth,
                          // maxHeight: contentHeight,
                        ),
                        child: _buildLoginForm(),
                      )
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    print('build login form');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _loginFormKey,
          child: Column(

            children: [
              Row(children: [Text('登入'),]),
              SizedBox(height: 20,),
              _buildAccountTextFormField(),
              SizedBox(height: 20,),
              _buildPasswordTextFormField(),
              Row(children: [
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus(); // for 收起鍵盤
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius
                              .circular(16))
                      ),
                      builder: (context) => const ForgotPasswordBottomSheet(),
                    );
                  },
                  child: const Text('忘記密碼'),
                ),
              ],),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () async {
                  String account = _accountController.text.trim();
                  String password = _passwordController.text.trim();
                  await ref.read(authProvider.notifier).login(account, password, _loginFormKey);
                },
                child: Text('登入')
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTextFormField() {
    print('build account input');
    return TextFormField(
      controller: _accountController,
      maxLength: 20,
      decoration: InputDecoration(
        labelText: '帳號',
        prefixIcon: Icon(Icons.account_circle),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '帳號不能為空';
        }
        if (value.length > 20) {
          return '帳號密碼最多20個字符';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordTextFormField() {
    print('build password input');
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      maxLength: 20,
      decoration: InputDecoration(
        labelText: '密碼',
        // labelStyle: appTheme.textTheme.titleMedium,
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '密碼不能為空';
        }
        if (value.length < 6) {
          return '密碼應大於6位';
        }
        if (value.length > 20) {
          return '帳號密碼最多20個字符';
        }
        return null;
      },
    );
  }
}
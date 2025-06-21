import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/providers/auth_provider.dart';

class ProfilePage extends ConsumerStatefulWidget{
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('個人檔案'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('ID開頭為F為管理員，開頭為4為採購人員，開頭為2為倉管人員，開頭為1為銷售人員')),
              );
            },
          )
        ],
      ),
      body: Center(
        heightFactor: 1,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '姓名：${ref.read(authProvider.notifier).user?.name ?? '你哪位?'}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '職位：${ref.read(authProvider.notifier).showPosition()}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'ID：${ref.read(authProvider.notifier).user?.id ?? '你哪位?'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '電子郵件：${ref.read(authProvider.notifier).user?.association.email ?? '查無電子郵件'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '電話：${ref.read(authProvider.notifier).user?.association.phone ?? '查無電話'}',
                  style: TextStyle(fontSize: 16),
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).logout(); // 清除使用者狀態
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login', // 回到 login 頁面
                        (route) => false, // 把所有舊頁面都移除
                      );
                    },
                    child: const Text('登出'),
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
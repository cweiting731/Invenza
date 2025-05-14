import 'package:flutter/material.dart';

class DialogUtils {
  /// 顯示 loading 對話框
  static void showLoading(BuildContext context, String title, {String message = '請稍候...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 4),
            ),
            SizedBox(width: 16),
            Flexible(child: Text(message)),
          ],
        ),
      ),
    );
  }

  /// 關閉 Dialog（只關 Dialog 不會誤關頁面）
  static void dismiss(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  /// 顯示錯誤訊息
  static void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => AlertDialog(
        title: Text('錯誤'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text('確定'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/log_service.dart';

final logProvider = Provider<LogService>((ref) {
  return LogService(); // ✅ 這裡呼叫 factory，永遠回傳同一個 Singleton 實例
});
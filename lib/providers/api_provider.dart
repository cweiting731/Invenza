import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';
import 'log_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final logger = ref.read(logProvider); // ✅ 依賴注入
  return ApiClient(logger);
});
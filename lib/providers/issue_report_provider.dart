import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/log_provider.dart';
import 'package:invenza/services/api_client.dart';
import 'package:invenza/services/log_service.dart';

import '../models/condition.dart';

final issueReportProvider = StateNotifierProvider.autoDispose<IssueReportController, AsyncValue<String>>(
    (ref) {
      final logger = ref.read(logProvider);
      final api = ref.read(apiClientProvider);
      return IssueReportController(logger, api);
    }
);

class IssueReportController extends StateNotifier<AsyncValue<String>> {
  final LogService _logger;
  final ApiClient _api;
  IssueReportController(this._logger, this._api) : super(const AsyncValue.data(''));

  Future<void> submit(String issue) async {
    state = AsyncValue.loading();

    try {
      final data = await _api.post(
        'http://localhost:8080/api/issue-report',
        Condition(
          'IssueReport',
          {
            'issue' : issue,
            'logs' : _logger.exportAsJson()
          }
        )
      );

      if (data['success']) {
        state = const AsyncValue.data('問題回報成功，請等待作業人員回覆');
        print('submit success');
      } else {
        throw Exception('問題回報失敗');
      }
    }
    catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
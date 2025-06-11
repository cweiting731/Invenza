import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/transfer_data/issue_report_data.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/api_route.dart';
import 'package:invenza/providers/log_provider.dart';
import 'package:invenza/services/api_client.dart';
import 'package:invenza/services/log_service.dart';

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
      await _api.post(
        ApiRoute.getRoute('issue-report'),
        IssueReportData(issue, _logger.exportAsJson()),
      );

      state = const AsyncValue.data('問題回報成功，請等待作業人員回覆');
    }
    catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
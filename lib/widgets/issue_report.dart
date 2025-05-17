import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/providers/issue_report_provider.dart';
import 'package:invenza/providers/log_provider.dart';
import 'package:invenza/widgets/dialog_utils.dart';

import '../providers/api_provider.dart';

class IssueReport extends ConsumerStatefulWidget {
  const IssueReport({super.key});
  
  @override
  ConsumerState<IssueReport> createState() => _IssueReportState();
}

class _IssueReportState extends ConsumerState<IssueReport> {
  final _IssueTextController = TextEditingController();
  String? info = null;
  Color infoColor = Colors.black87;

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final issueReportState = ref.watch(issueReportProvider);
    final api = ref.read(apiClientProvider);
    final logger = ref.read(logProvider);

    String transferOrComfirm = '送出';

    String? info;
    Color infoColor = Colors.black87;

    if (issueReportState.isLoading) {
      info = '傳送中...';
    } else if (issueReportState.hasError) {
      logger.error('issue report: ${issueReportState.error}');
      info = api.formatErrorMessage(issueReportState.error);
      infoColor = Colors.red;
    } else if (issueReportState.hasValue && issueReportState.value != '') {
      logger.info('issue report: transfer successfully');
      transferOrComfirm = '確認';
      info = issueReportState.value;
      infoColor = Colors.green;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double contentWidth = screenWidth > 900
            ? 800 // 大螢幕
            : screenWidth * 0.85; // 小螢幕
        double screenHeight = constraints.maxHeight;
        double contentHeight = screenHeight > 600
            ? 500
            : screenHeight * 0.85;

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: contentWidth,
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(children: [Text('問題回報')],),
                const SizedBox(height: 24,),
                TextField(
                  controller: _IssueTextController,
                  minLines: 3,
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: '問題',
                    hintText: '請簡要描述你遇到的問題',
                    prefixIcon: Icon(Icons.question_mark_rounded),
                  ),
                ),
                const SizedBox(height: 24,),
                if (issueReportState.hasValue && issueReportState.value == '')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 1,),
                      ElevatedButton(
                          onPressed: () {
                            logger.info('issue report: cancel');
                            DialogUtils.dismiss(context);
                          },
                          child: const Text('取消')
                      ),
                      SizedBox(width: 1,),
                      ElevatedButton(
                          onPressed: () async {
                            logger.info('issue report: transfer');
                            final issue = _IssueTextController.text.trim();
                            await ref.read(issueReportProvider.notifier).submit(issue);
                          },
                          child: Text('送出')
                      ),
                      SizedBox(width: 1,)
                    ],
                  ),
                if (issueReportState.hasValue && issueReportState.value != '')
                  ElevatedButton(
                      onPressed: () {
                        logger.info('issue report: confirm');
                        DialogUtils.dismiss(context);
                      },
                      child: const Text('確認')
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
    );
  }
}
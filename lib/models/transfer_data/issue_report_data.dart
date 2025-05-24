import 'dart:convert';

import 'package:invenza/interface/serializable.dart';

class IssueReportData implements Serializable {
  final String issue;
  final List log;

  IssueReportData(this.issue, this.log);

  @override
  String serialization() {
    return jsonEncode(
      {
        'issue' : issue,
        'logs' : log,
      }
    );
  }

  @override
  void deserialization() {
    // TODO: implement deserialization
  }
}
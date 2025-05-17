import 'dart:convert';

class LogService {
  // 靜態私有實例（全域唯一）
  static final LogService _instance = LogService._internal();

  // 提供一個公開的單例工廠
  factory LogService() => _instance;

  // 私有建構子（只能在內部使用）
  LogService._internal();

  final List<LogEntry> _logs = [];

  void _add(String level, String msg) {
    final datetime = DateTime.now().toIso8601String();
    _logs.add(LogEntry(level, datetime, msg));
  }

  void clear() => _logs.clear();

  void info(String msg) => _add('INFO', msg);
  void debug(String message) => _add('DEBUG', message);
  void error(String message) => _add('ERROR', message);

  List<LogEntry> getLogs() => List.unmodifiable(_logs);

  List exportAsJson() {
    return _logs.map((e) => e.toJson()).toList();
  }
}

class LogEntry {
  final String level;
  final String timestamp;
  final String message;

  LogEntry(this.level, this.timestamp, this.message);

  Map<String, dynamic> toJson() => {
    'level': level,
    'timestamp': timestamp,
    'message': message,
  };
}
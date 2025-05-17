import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/condition.dart';
import 'log_service.dart';

class ApiClient {
  final LogService logger;

  ApiClient(this.logger);

  // 方法
  Future<Map<String, dynamic>> post(String url, Condition condition) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: condition.serialization(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? '伺服器錯誤 (${response.statusCode})');
      }
    } on SocketException catch (e, st) {
      Error.throwWithStackTrace(Exception('無法連接伺服器，請檢查網路連線'), st);
    } on FormatException catch (e, st) {
      Error.throwWithStackTrace(Exception('資料格式錯誤，請聯繫開發人員'), st);
    } on http.ClientException catch (e, st) {
      Error.throwWithStackTrace(Exception('連線失敗，請確認伺服器是否有開啟'), st);
    } catch (e, st) {
      Error.throwWithStackTrace(Exception('未知錯誤：$e'), st);
    }
  }

  String formatErrorMessage(Object? error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error?.toString() ?? '未知錯誤';
  }
}

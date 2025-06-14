import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:invenza/interface/serializable.dart';
import 'log_service.dart';
import 'package:invenza/logger/logger.dart';

class ApiClient {
  final LogService logger;

  ApiClient(this.logger);

  // 方法
  Future<Map<String, dynamic>> post(String url, Serializable transferData, {String token = ''}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : 'Bearer $token',
        },
        body: transferData.serialization(),
      );

      log.i('Response headers: ${response.headers}');
      log.i('Response body (pretty):\n${ JsonEncoder.withIndent('  ').convert(jsonDecode(utf8.decode(response.bodyBytes))) }');
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      /* TODO: statusCode 各個判斷 */
      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['error'] ?? '伺服器錯誤 (${response.statusCode})');
      }
    } on SocketException catch (e, st) {
      Error.throwWithStackTrace(Exception('無法連接伺服器，請檢查網路連線'), st);
    } on FormatException catch (e, st) {
      Error.throwWithStackTrace(Exception('資料格式錯誤，請聯繫開發人員'), st);
    } on http.ClientException catch (e, st) {
      Error.throwWithStackTrace(Exception('連線失敗，請確認伺服器是否有開啟'), st);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> get(String url, {Map<String, String>? queryParams, String token = ''}) async {
    try {
      final uri = Uri.parse(url).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      log.i('Response headers: ${response.headers}');
      log.i('Response body (pretty):\n${ JsonEncoder.withIndent('  ').convert(jsonDecode(utf8.decode(response.bodyBytes))) }');
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['error'] ?? '伺服器錯誤 (${response.statusCode})');
      }
    } on SocketException catch (e, st) {
      Error.throwWithStackTrace(Exception('無法連接伺服器，請檢查網路連線'), st);
    } on FormatException catch (e, st) {
      Error.throwWithStackTrace(Exception('資料格式錯誤，請聯繫開發人員'), st);
    } on http.ClientException catch (e, st) {
      Error.throwWithStackTrace(Exception('連線失敗，請確認伺服器是否有開啟'), st);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(String url, Serializable transferData, {String token = ''}) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: transferData.serialization(),
      );

      log.i('Response headers: ${response.headers}');
      log.i('Response body (pretty):\n${ JsonEncoder.withIndent('  ').convert(jsonDecode(utf8.decode(response.bodyBytes))) }');
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['error'] ?? '伺服器錯誤 (${response.statusCode})');
      }
    } on SocketException catch (e, st) {
      Error.throwWithStackTrace(Exception('無法連接伺服器，請檢查網路連線'), st);
    } on FormatException catch (e, st) {
      Error.throwWithStackTrace(Exception('資料格式錯誤，請聯繫開發人員'), st);
    } on http.ClientException catch (e, st) {
      Error.throwWithStackTrace(Exception('連線失敗，請確認伺服器是否有開啟'), st);
    } catch (e) {
      rethrow;
    }
  }

  String formatErrorMessage(Object? error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error?.toString() ?? '未知錯誤';
  }
}

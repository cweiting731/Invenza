
class ApiRoute {
  // static const _serverAddress = 'http://192.168.215.198:8080';
  static const _serverAddress = 'http://localhost:8080';
  static const Map<String, String> _apiRoute = {
    'auth' : '/api/auth/login',
    'forgot-password' : '/api/auth/forgot-password',
    'issue-report' : '/api/issue-report',

    'procurement-get-data' : '/api/procurement/get-data'
  };

  static String getRoute(String type) => '$_serverAddress${_apiRoute[type]}';
}
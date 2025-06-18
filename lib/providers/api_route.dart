
class ApiRoute {
  // static const _serverAddress = 'http://192.168.215.198:8080';
  // static const _serverAddress = 'http://localhost:8080';
  static const _serverAddress = 'http://192.168.209.169:8080';
  static const Map<String, String> _apiRoute = {
    'auth' : '/api/auth/login',
    'forgot-password' : '/api/auth/forgot-password',
    'issue-report' : '/api/issue-report',

    'procurement-get-data' : '/api/procurement/get-data',
    'procurement-add-data' : '/api/procurement/add-data',
    'procurement-update-data' : '/api/procurement/update-data',
    'procurement-delete-data' : '/api/procurement/delete-data',
    'inventory-get-data' : '/api/inventory/get-data', 
    'inventory-add-request' : '/api/inventory/add-request',
  };

  static String getRoute(String type) => '$_serverAddress${_apiRoute[type]}';
}
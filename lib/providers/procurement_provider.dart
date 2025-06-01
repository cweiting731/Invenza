import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/models/import_order.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/api_route.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/services/api_client.dart';

final importOrdersProvider = FutureProvider.family<List<ImportOrder>, FilterOptions>((ref, filters) async {
  final repo = ref.read(procurementRepositoryProvider);
  return repo.fetchOrders(filters: filters);
});

final procurementRepositoryProvider = Provider<ProcurementRepository>((ref) {
  final api = ref.read(apiClientProvider);
  final user = ref.read(userProvider);
  return ProcurementRepository(api, user);
});

class ProcurementRepository {
  final ApiClient _api;
  final Employee? _user;

  ProcurementRepository(this._api, this._user);

  Future<List<ImportOrder>> fetchOrders({FilterOptions? filters}) async {
    final queryParams = filters?.toQueryParams();

    try {
      if (_user == null || _user.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }
      final data = await _api.get(
        ApiRoute.getRoute('procurement-get-data'),
        queryParams: queryParams,
        token: _user.jwtToken!
      );

      final List rawData = data['data'];
      return rawData.map( (order) => ImportOrder.fromJson(order)).toList();
    } catch (e, st) {
      rethrow;
    }
  }
}
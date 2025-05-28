

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/models/inventory_item.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/api_route.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/services/api_client.dart';

final inventoryItemsProvider = FutureProvider.family<List<InventoryItem>, FilterOptions>((ref, filters) async {
  final repo = ref.read(inventoryRepositoryProvider);
  return repo.fetchItems(filters: filters);
});

final inventoryRepositoryProvider = Provider<InventoryRepository> ((ref) {
  final api = ref.read(apiClientProvider);
  final user = ref.read(userProvider);
  return InventoryRepository(api, user);
});

class InventoryRepository {
  final ApiClient _api;
  final Employee? _user;

  InventoryRepository(this._api, this._user);

  Future<List<InventoryItem>> fetchItems({FilterOptions? filters}) async {
    final queryParams = filters?.toQueryParams();

    try {
      if (_user == null || _user.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }
      final data = await _api.get(
        ApiRoute.getRoute('inventory-get-data'),
        queryParams: queryParams,
        token: _user.jwtToken!
      );

      final List rawData = data['data'];
      return rawData.map( (item) => InventoryItem.fromJson(item)).toList();
    } catch (e, st) {
      rethrow;
    }
  }

}
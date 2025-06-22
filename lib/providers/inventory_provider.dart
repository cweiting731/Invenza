

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/models/inventory_item.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/models/transfer_data/inventory_request.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/api_route.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/services/api_client.dart';

// 提供filter選項的global Provider
final inventoryFilterProvider = StateProvider<FilterOptions>((ref) {
  return FilterOptions();
});

// 讀取filter並處理fetch的Provider
final inventoryItemsProvider = StateNotifierProvider<InventoryItemsNotifier, AsyncValue<List<InventoryItem>>>(
  (ref) {
  final repo = ref.read(inventoryRepositoryProvider);
  final filter = ref.watch(inventoryFilterProvider);
  return InventoryItemsNotifier(repo, filter)..fetchItems();
});

class InventoryItemsNotifier extends StateNotifier<AsyncValue<List<InventoryItem>>> {
  final InventoryRepository _repo;
  final FilterOptions _filters;

  InventoryItemsNotifier(this._repo, this._filters) : super(const AsyncLoading());

  Future<void> fetchItems() async {
    try {
      final items = await _repo.fetchItems(filters: _filters);
      state = AsyncData(items);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final addInventoryRequestProvider = StateNotifierProvider.autoDispose<AddInventoryRequestNotifier, AsyncValue<String?>>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return AddInventoryRequestNotifier(repo);
});

class AddInventoryRequestNotifier extends StateNotifier<AsyncValue<String?>> {
  final InventoryRepository _repo;

  AddInventoryRequestNotifier(this._repo) : super(const AsyncData(null));

  Future<void> addRequest(InventoryRequest request) async {
    state = const AsyncLoading();
    try {
      await _repo.addRequest(request);
      state = const AsyncData('success');
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// 提供InventoryRepository的Provider
final inventoryRepositoryProvider = Provider<InventoryRepository> ((ref) {
  final api = ref.read(apiClientProvider);
  final user = ref.watch(authProvider).maybeWhen(
    data: (u) => u,
    orElse: () => null,
  );
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

      final List? rawData = data['data'];
      return rawData?.map( (item) => InventoryItem.fromJson(item)).toList() ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addRequest(InventoryRequest request) async {
    try {
      if (_user == null || _user.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }

      await _api.post(
        ApiRoute.getRoute('inventory-add-request'),
        request,
        token: _user.jwtToken!
      );
    } catch (e) {
      rethrow;
    }
  }
}
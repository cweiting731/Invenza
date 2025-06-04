import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/models/import_order.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/api_route.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/services/api_client.dart';

final importOrdersProvider = StateNotifierProvider.family<ImportOrdersNotifier, AsyncValue<List<ImportOrder>>, FilterOptions>(
        (ref, filters) {
      final repo = ref.read(procurementRepositoryProvider);
      return ImportOrdersNotifier(repo, filters)..fetchOrders();
    }
);

class ImportOrdersNotifier extends StateNotifier<AsyncValue<List<ImportOrder>>> {
  final ProcurementRepository _repo;
  final FilterOptions _filters;

  ImportOrdersNotifier(this._repo, this._filters) : super(const AsyncLoading());

  Future<void> fetchOrders() async {
    print('import order fetch order');
    try {
      final orders = await _repo.fetchOrders(filters: _filters);
      print('success order');
      state = AsyncData(orders);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void updateOrders(List<ImportOrder> orders) {
    state = AsyncData(orders);
  }
}

final addImportOrderProvider = StateNotifierProvider.autoDispose<AddImportOrderNotifier, AsyncValue<String?>>((ref) {
  final repo = ref.watch(procurementRepositoryProvider);
  return AddImportOrderNotifier(repo, ref);
});

class AddImportOrderNotifier extends StateNotifier<AsyncValue<String?>> {
  final ProcurementRepository _repo;
  final Ref _ref;

  AddImportOrderNotifier(this._repo, this._ref) : super(const AsyncData(null));

  Future<void> addOrder(ImportOrder order, FilterOptions filters) async {
    state = const AsyncLoading();
    try {
      await _repo.addOrder(order);
      state = const AsyncData('success');
      // // 直接更新資料或重新拉取資料
      // final updatedOrders = await _repo.fetchOrders(filters: filters);
      // print(updatedOrders);
      // _ref.read(importOrdersProvider(filters).notifier).updateOrders(updatedOrders);


    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

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

  Future<void> addOrder(ImportOrder order) async {
    try {
      if (_user == null || _user.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }

      final data = await _api.post(
        ApiRoute.getRoute('procurement-add-data'),
        order
      );
    } catch (e, st) {
      rethrow;
    }
  }
}
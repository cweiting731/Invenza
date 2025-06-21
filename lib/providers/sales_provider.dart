import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/models/export_order.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/api_route.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/services/api_client.dart';




final exportOrderFilterProvider = StateProvider<FilterOptions>((ref) {
  return FilterOptions(deadlineEnd: DateTime.now());
});

final exportOrdersProvider = StateNotifierProvider<ExportOrdersNotifier, AsyncValue<List<ExportOrder>>>(
  (ref) {
    final repo = ref.read(salesRepositoryProvider);
    final filter = ref.watch(exportOrderFilterProvider);
    return ExportOrdersNotifier(repo, filter)..fetchOrders();
  }
);

class ExportOrdersNotifier extends StateNotifier<AsyncValue<List<ExportOrder>>> {
  final SalesRepository _repo;
  final FilterOptions _filters;

  ExportOrdersNotifier(this._repo, this._filters) : super(const AsyncLoading());

  Future<void> fetchOrders() async {
    try {
      final orders = await _repo.fetchOrders(filters: _filters);
      state = AsyncData(orders);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// 提供新增訂單的Provider
final addExportOrderProvider = StateNotifierProvider.autoDispose<AddExportOrderNotifier, AsyncValue<String?>>((ref) {
  final repo = ref.watch(salesRepositoryProvider);
  return AddExportOrderNotifier(repo);
});

class AddExportOrderNotifier extends StateNotifier<AsyncValue<String?>> {
  final SalesRepository _repo;

  AddExportOrderNotifier(this._repo) : super(const AsyncData(null));

  Future<void> addOrder(ExportOrder order) async {
    state = const AsyncLoading();
    try {
      await _repo.addOrder(order);
      state = const AsyncData('success');
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// 提供編輯訂單的Provider
final editExportOrderProvider = StateNotifierProvider.autoDispose<EditExportOrderNotifier, AsyncValue<String?>>((ref) {
  final repo = ref.watch(salesRepositoryProvider);
  return EditExportOrderNotifier(repo);
});

class EditExportOrderNotifier extends StateNotifier<AsyncValue<String?>> {
  final SalesRepository _repo;

  EditExportOrderNotifier(this._repo) : super(const AsyncData(null));

  Future<void> editOrder(ExportOrder order) async {
    state = const AsyncLoading();
    try {
      await _repo.editOrder(order);
      state = const AsyncData('success');
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// 提供刪除訂單的Provider
final deleteExportOrderProvider = StateNotifierProvider.autoDispose<DeleteExportOrderNotifier, AsyncValue<String?>>((ref) {
  final repo = ref.watch(salesRepositoryProvider);
  return DeleteExportOrderNotifier(repo);
});

class DeleteExportOrderNotifier extends StateNotifier<AsyncValue<String?>> {
  final SalesRepository _repo;

  DeleteExportOrderNotifier(this._repo) : super(const AsyncData(null));

  Future<void> deleteOrder(ExportOrder order) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteOrder(order);
      state = const AsyncData('success');
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  final user = ref.watch(authProvider).maybeWhen(
    data: (u) => u,
    orElse: () => null,
  );
  return SalesRepository(api, user);
});

class SalesRepository {
  final ApiClient _api;
  final Employee? _user;

  SalesRepository(this._api, this._user);

  Future<List<ExportOrder>> fetchOrders({FilterOptions? filters}) async {
    final queryParams = filters?.toQueryParams();

    try {
      if (_user == null || _user.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }
      final data = await _api.get(
        ApiRoute.getRoute('sales-get-data'),
        queryParams: queryParams,
        token: _user.jwtToken!
      );

      final List rawData = data['data'];
      return rawData.map( (order) => ExportOrder.fromJson(order)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrder(ExportOrder order) async {
    try {
      if (_user == null || _user.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }

      await _api.post(
        ApiRoute.getRoute('sales-add-data'),
        order, 
        token: _user.jwtToken!
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editOrder(ExportOrder order) async {
    try {
      if (_user == null || _user.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }

      await _api.put(
        ApiRoute.getRoute('sales-update-data'),
        order, 
        token: _user.jwtToken!
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteOrder(ExportOrder order) async {
    try {
      if (_user == null || _user.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }

      await _api.delete(
        ApiRoute.getRoute('sales-delete-data'),
        {
          'id': order.id?.toString() ?? '',
        },
        token: _user.jwtToken!
      );
    } catch (e) {
      rethrow;
    }
  }
}
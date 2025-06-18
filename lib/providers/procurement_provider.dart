import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/models/import_order.dart';
import 'package:invenza/models/transfer_data/filter_options.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/api_route.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/services/api_client.dart';

// 提供filter選項的global Provider
final importOrderFilterProvider = StateProvider<FilterOptions>((ref) {
  return FilterOptions(deadlineEnd: DateTime.now());
});

// 讀取filter並處理fetch的Provider
final importOrdersProvider = StateNotifierProvider<ImportOrdersNotifier, AsyncValue<List<ImportOrder>>>(
        (ref) {
      final repo = ref.read(procurementRepositoryProvider);
      final filter = ref.watch(importOrderFilterProvider);
      return ImportOrdersNotifier(repo, filter)..fetchOrders();
    }
);

class ImportOrdersNotifier extends StateNotifier<AsyncValue<List<ImportOrder>>> {
  final ProcurementRepository _repo;
  final FilterOptions _filters;

  ImportOrdersNotifier(this._repo, this._filters) : super(const AsyncLoading());

  Future<void> fetchOrders() async {
    try {
      final orders = await _repo.fetchOrders(filters: _filters);
      state = AsyncData(orders);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // void updateOrders(List<ImportOrder> orders) {
  //   state = AsyncData(orders);
  // }
}

// 提供新增訂單的Provider
final addImportOrderProvider = StateNotifierProvider.autoDispose<AddImportOrderNotifier, AsyncValue<String?>>((ref) {
  final repo = ref.watch(procurementRepositoryProvider);
  return AddImportOrderNotifier(repo);
});

class AddImportOrderNotifier extends StateNotifier<AsyncValue<String?>> {
  final ProcurementRepository _repo;

  AddImportOrderNotifier(this._repo) : super(const AsyncData(null));

  Future<void> addOrder(ImportOrder order) async {
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
final editImportOrderProvider = StateNotifierProvider.autoDispose<EditImportOrderNotifier, AsyncValue<String?>>((ref) {
  final repo = ref.watch(procurementRepositoryProvider);
  return EditImportOrderNotifier(repo);
});

class EditImportOrderNotifier extends StateNotifier<AsyncValue<String?>> {
  final ProcurementRepository _repo;

  EditImportOrderNotifier(this._repo) : super(const AsyncData(null));

  Future<void> editOrder(ImportOrder order) async {
    state = const AsyncLoading();
    try {
      await _repo.editOrder(order);
      if (mounted) {
        state = const AsyncData('success');
      }
    } catch (e, st) {
      if (mounted) {
        state = AsyncError(e, st);
      }
    }
  }
}

// 提供刪除訂單的Provider
final deleteImportOrderProvider = StateNotifierProvider.autoDispose<DeleteImportOrderNotifier, AsyncValue<String?>>((ref) {
  final repo = ref.watch(procurementRepositoryProvider);
  return DeleteImportOrderNotifier(repo);
});

class DeleteImportOrderNotifier extends StateNotifier<AsyncValue<String?>> {
  final ProcurementRepository _repo;

  DeleteImportOrderNotifier(this._repo) : super(const AsyncData(null));

  Future<void> deleteOrder(ImportOrder order) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteOrder(order);
      if (mounted) {
        state = const AsyncData('success');
      }
    } catch (e, st) {
      if (mounted) {
        state = AsyncError(e, st);
      }
    }
  }
}

// 提供ProcurementRepository的Provider
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
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrder(ImportOrder order) async {
    try {
      if (_user == null || _user.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }

      await _api.post(
        ApiRoute.getRoute('procurement-add-data'),
        order, 
        token: _user.jwtToken!
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editOrder(ImportOrder order) async {
    try {
      if (_user == null || _user.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }

      await _api.put(
        ApiRoute.getRoute('procurement-update-data'),
        order, 
        token: _user.jwtToken!
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteOrder(ImportOrder order) async {
    try {
      if (_user == null || _user.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }

      await _api.delete(
        ApiRoute.getRoute('procurement-delete-data'),
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
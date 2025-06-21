import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/models/inventory_item.dart';
import 'package:invenza/models/transfer_data/inventory_request.dart';
import 'package:invenza/pages/home_page/dashboard.dart';
import 'package:invenza/providers/api_provider.dart';
import 'package:invenza/providers/api_route.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/services/api_client.dart';

class DashboardState {
  final List<InventoryRequest>? procurementData;
  final List<InventoryRequest>? salesData;
  final List<InventoryItem>? inventoryData;
  final String? errorMessage;

  DashboardState({
    this.procurementData,
    this.salesData,
    this.inventoryData,
    this.errorMessage,
  });

  DashboardState copyWith({
    List<InventoryRequest>? procurementData,
    List<InventoryRequest>? salesData,
    List<InventoryItem>? inventoryData,
    String? errorMessage,
  }) {
    return DashboardState(
      procurementData: procurementData ?? this.procurementData,
      salesData: salesData ?? this.salesData,
      inventoryData: inventoryData ?? this.inventoryData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory DashboardState.initial() {
    return DashboardState();
  }
}

final dashboardErrorProvider = StateProvider<String?>((ref) => null);

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>(
  (ref) {
    final user = ref.read(userProvider);
    final api = ref.read(apiClientProvider);
    return DashboardNotifier(user: user, api: api, ref: ref);
  },
);

class DashboardNotifier extends StateNotifier<DashboardState> {
  final Employee? user;
  final ApiClient api;
  final Ref ref;
  DashboardNotifier({this.user, required this.api, required this.ref}) : super(DashboardState.initial());

  void reset() {
    state = DashboardState.initial();
  }

  Future<void> fetchAllData() async {
    try {
      await fetchProcurementData();
      await fetchSalesData();
      await fetchInventoryData();
    } catch (e) {
      // Handle errors if needed
      
    }
  }

  Future<void> fetchProcurementData() async {
    try {
      if (user == null || user!.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }
      final data = await api.get(
        ApiRoute.getRoute('dashboard-get-procurement-requests'),
        token: user!.jwtToken!,
      );
      final procurementData = (data['data'] as List)
          .map((item) => InventoryRequest.fromJson(item))
          .toList();
      state = state.copyWith(procurementData: procurementData);
    } catch (e) {
      state = state.copyWith(procurementData: [], errorMessage: null);
    }
  }

  Future<void> fetchSalesData() async {
    try {
      if (user == null || user!.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }
      final data = await api.get(
        ApiRoute.getRoute('dashboard-get-saler-requests'),
        token: user!.jwtToken!,
      );
      final salesData = (data['data'] as List)
          .map((item) => InventoryRequest.fromJson(item))
          .toList();
      state = state.copyWith(salesData: salesData);
    } catch (e) {
      state = state.copyWith(salesData: [], errorMessage: null);
    }
  }

  Future<void> fetchInventoryData() async {
    try {
      if (user == null || user!.jwtToken == null) {
        throw Exception('尚未登入，你怎麼進來的?');
      }
      final data = await api.get(
        ApiRoute.getRoute('dashboard-get-inventory-data'),
        token: user!.jwtToken!,
      );
      final inventoryData = (data['data'] as List)
          .map((item) => InventoryItem.fromJson(item))
          .toList();
      state = state.copyWith(inventoryData: inventoryData);
    } catch (e) {
      state = state.copyWith(inventoryData: [], errorMessage: null);
    }
  }
  
}

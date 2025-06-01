// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/pages/home_page/inventory_page.dart';
import 'package:invenza/pages/home_page/procurement_page.dart';
import '../../providers/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<TabItem> tabItems = [
    TabItem(
      title: '首頁',
      idleIcon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      page: Center(child: Text('這是首頁'),)
    ),
    TabItem(
        title: '進貨列表',
        idleIcon: Icons.input,
        selectedIcon: Icons.input_sharp,
        page: ProcurementPage()
    ),
    TabItem(
        title: '庫存',
        idleIcon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
        page: InventoryPage()
    ),
    TabItem(
        title: '出貨列表',
        idleIcon: Icons.output,
        selectedIcon: Icons.output_sharp,
        page: Center(child: Text('這是出貨列表'),)
    ),
    TabItem(
        title: '行事曆',
        idleIcon: Icons.calendar_today_outlined,
        selectedIcon: Icons.calendar_month,
        page: Center(child: Text('這是行事曆'),)
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabItems.length, vsync: this);

    _tabController.addListener(() {
      // if (_tabController.indexIsChanging) return; // 等到動畫完成
      setState(() {}); // 觸發 rebuild，讓 title 跟著變
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).asData?.value;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return isMobile
        ? _buildMobileLayout(user)
        : _buildTabletOrDesktopLayout(user);
  }

  Widget _buildMobileLayout(Employee? user) {
    return Center(child: Text('手機端尚未做設定'));
  }

  Widget _buildTabletOrDesktopLayout(Employee? user) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tabItems[_tabController.index].title),
        bottom: TabBar(
          controller: _tabController,
          tabs: List.generate(tabItems.length, (index) {
              final item = tabItems[index];
              final isSelected = _tabController.index == index;
              return Tab(
                text: item.title,
                icon: Icon(
                  isSelected ? item.selectedIcon : item.idleIcon,
                  color: isSelected ? Colors.green : Colors.red,
                ),
              );
            }
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabItems.map((item) => item.page).toList()
      ),
    );
  }
}

class TabItem {
  final String title;
  final IconData idleIcon;
  final IconData selectedIcon;
  final Widget page;

  TabItem({required this.title, required this.idleIcon, required this.selectedIcon,required this.page});
}

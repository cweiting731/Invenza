// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/pages/home_page/dashboard.dart';
import 'package:invenza/pages/home_page/inventory_page.dart';
import 'package:invenza/pages/home_page/procurement_page.dart';
import 'package:invenza/pages/home_page/profile_page.dart';
import 'package:invenza/pages/home_page/sales_page.dart';
import '../../providers/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  int _index = 0;
  final List<TabItem> tabItems = [
    TabItem(
      title: '首頁',
      idleIcon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      page: Dashboard(),
    ),
    TabItem(
        title: '進貨列表',
        idleIcon: Icons.input,
        selectedIcon: Icons.input_sharp,
        page: ProcurementPage(),
    ),
    TabItem(
        title: '庫存',
        idleIcon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
        page: InventoryPage(),
    ),
    TabItem(
        title: '出貨列表',
        idleIcon: Icons.output,
        selectedIcon: Icons.output_sharp,
        page: SalesPage(),
    ),
    TabItem(
        title: '個人檔案',
        idleIcon: Icons.person_outline,
        selectedIcon: Icons.person,
        page: ProfilePage()
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider.notifier).user;
    if (user == null || user.jwtToken == null || user.jwtToken!.isEmpty) {
      return Scaffold(
        body: Center(child: Text('請先登入')),
      );
    }

    return _buildContainer(user);
  }

  Widget _buildContainer(Employee? user) {
    return Scaffold(
      body: tabItems[_index].page,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          BottomNavigationBarItem(icon: Icon(tabItems[0].idleIcon), label: tabItems[0].title),
          BottomNavigationBarItem(icon: Icon(tabItems[1].idleIcon), label: tabItems[1].title),
          BottomNavigationBarItem(icon: Icon(tabItems[2].idleIcon), label: tabItems[2].title),
          BottomNavigationBarItem(icon: Icon(tabItems[3].idleIcon), label: tabItems[3].title),
          BottomNavigationBarItem(icon: Icon(tabItems[4].idleIcon), label: tabItems[4].title),
        ]

      )
    );
  }
}

class TabItem {
  final String title;
  final IconData idleIcon;
  final IconData selectedIcon;
  final Widget page;
  final Widget Function(BuildContext)? floatingAction;

  TabItem({required this.title, required this.idleIcon, required this.selectedIcon,required this.page, this.floatingAction});
}

// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/models/employee.dart';
import 'package:invenza/pages/home_page/edit_procurement_dialog.dart';
import 'package:invenza/pages/home_page/inventory_page.dart';
import 'package:invenza/pages/home_page/procurement_page.dart';
import 'package:invenza/theme/theme.dart';
import '../../providers/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  int _index = 1;
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
        page: ProcurementPage(),
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
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).asData?.value;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return _buildTabletOrDesktopLayout(user);

    return isMobile
        ? _buildMobileLayout(user)
        : _buildTabletOrDesktopLayout(user);
  }

  Widget _buildMobileLayout(Employee? user) {
    return Center(child: Text('手機端尚未做設定'));
  }

  Widget _buildTabletOrDesktopLayout(Employee? user) {
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

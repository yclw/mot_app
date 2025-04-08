import '/features/feedback/feedback_page.dart';
import '/features/statistics/statistics_page.dart';
import '../monitor/monitor_page.dart';
import '/features/home/widgets/drawer.dart';
import 'package:flutter/material.dart';
import '../analyze/analyze_page.dart';
import '/core/themes/app_colors.dart';
import './widgets/custom_bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _selectedIndex = 0;

  // 页面组件列表
  final List<Widget> _pages = [
    EnvironmentMonitorPage(),
    StatisticsPage(),
    AnalyzePage(),
    FeedbackPage()
  ];

  void navigateBottomNavBar(int index) {
    setState(() {
      _selectedIndex = index.clamp(0, _pages.length - 1);
    });
  }

  // 跳转到设置页面
  void navigateToSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // 抽屉
      drawer: MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.navBarBackground,
        surfaceTintColor: AppColors.transparent,
        leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }
        ),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: navigateToSettings,
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        onTabChange: navigateBottomNavBar,
      ),
    );
  }
}
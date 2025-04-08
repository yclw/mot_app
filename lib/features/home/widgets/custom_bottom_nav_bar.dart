import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '/core/themes/app_colors.dart';

// 底部导航栏
class CustomBottomNavBar extends StatelessWidget {
  final Function(int)? onTabChange;
  // 构造函数
  const CustomBottomNavBar({super.key, required this.onTabChange});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: GNav(
        padding: EdgeInsets.all(5.0),
        backgroundColor: AppColors.navBackground, // 背景色
        activeColor: AppColors.navSelected, // 选中的图标和文字颜色
        color: AppColors.navUnselected, // 未选中的图标和文字颜色
        style: GnavStyle.google,
        tabBackgroundColor: AppColors.navSelectedBackground, // 选中的背景色
        gap: 20, // 图标和文字之间的间距
        tabBorderRadius: 10,
        onTabChange: (value) => onTabChange!(value),
        tabs: const [
          GButton(
            icon: Icons.list_alt,
            text: '环境监控',
          ),
          GButton(
            icon: Icons.timeline,
            text: '详细查询',
          ),
          GButton(
            icon: Icons.analytics,
            text: 'ai分析',
          ),
          // GButton(
          //   icon: Icons.mail_outline,
          //   text: '意见反馈',
          // ),
        ],
      ),
    );
  }
}
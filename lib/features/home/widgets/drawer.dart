import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8,
      backgroundColor: AppColors.navBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        side: BorderSide(
          color: AppColors.divider,
          width: 0.5,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Column(
        children: [
          // 用户信息头部
          SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _withCustomAlpha(AppColors.primary, 204), // 0.8透明度
                      AppColors.secondary
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Card(
                  color: Colors.transparent,
                  elevation: 0,
                  child: Center(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(20),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.textQuaternary,
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text('YC',
                          style: TextStyle(
                              color: AppColors.textQuaternary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text('3286108868@qq.com',
                          style: TextStyle(
                              color: Color(0xCCF5F7F6))), // 0.8透明度
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 功能菜单
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.settings_rounded,
                  title: "系统设置",
                  route: '/settings',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.feedback_rounded,
                  title: "意见反馈",
                  route: '/feedback',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.info_rounded,
                  title: "关于系统",
                  route: '/about',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String route,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _withCustomAlpha(AppColors.navSelectedBackground, 77), // 0.3透明度
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 26,
          color: AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        minLeadingWidth: 24,
        horizontalTitleGap: 8,
        onTap: () => Navigator.pushNamed(context, route),
        hoverColor: AppColors.navSelectedBackground,
        splashColor: _withCustomAlpha(AppColors.primary, 25), // 0.1透明度
      ),
    );
  }

  // 精确透明度转换方法
  static Color _withCustomAlpha(Color color, int alpha) {
    return Color.fromARGB(
      alpha.clamp(0, 255),
      (color.r * 255.0).toInt(),
      (color.g * 255.0).toInt(),
      (color.b * 255.0).toInt(),
    );
  }
}
import 'package:flutter/material.dart';

abstract class AppColors {
  // 主色系
  static const Color primary = Color(0xFF4A6B57);    // 墨绿
  static const Color secondary = Color(0xFF78997A); // 苔藓绿

  // 中性色
  static const Color background = Color(0xFFF5F7F6); // 浅灰绿背景
  static const Color divider = Color(0xFFDCE4E0);    // 自然分割线

  // 文本色
  static const Color textPrimary = Color(0xFF2D4037);   // 深墨绿
  static const Color textSecondary = Color(0xFF6B8375); // 灰绿
  static const Color textTertiary = Color(0xFF9FB2A6);  // 浅灰绿
  static const Color textQuaternary = Color(0xFFF5F7F6); // 反白文字

  // 状态色
  static const Color success = Color(0xFF5D9B7E);    // 自然绿
  static const Color warning = Color(0xFFB3A16C);    // 橄榄黄
  static const Color error = Color(0xFFA34B4B);      // 暗红

  // 导航
  static const Color navBarBackground = Color(0xFFE2EAE5);  // 浅绿背景
  static const Color navBackground = Color(0xFFF5F7F6);     // 统一背景
  static const Color navSelected = Color(0xFF4A6B57);       // 主色
  static const Color navUnselected = Color(0xFF9FB2A6);     // 浅灰绿
  static const Color navSelectedBackground = Color(0xFFE2EAE5);

  // 对话框
  static const Color dialogBackground = Color(0xFFEDF3EF); // 浅绿灰

  // 提示
  static const Color snackBarBackground = Color(0xFFE2EAE5);

  // 透明
  static const Color transparent = Color(0x00000000);
}
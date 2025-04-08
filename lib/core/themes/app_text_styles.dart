import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // 导航栏标签
  static const TextStyle navLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // AppBar 标题
  static const TextStyle appBarTitle = TextStyle(
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      fontSize: 20
  );

  // 标题样式
  static const TextStyle title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.textQuaternary,
  );

  // 正文样式
  static const TextStyle body = TextStyle(
    fontSize: 16,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // 小标题
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // 弹窗样式
  static const TextStyle dialogTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  // 弹窗内容样式
  static const TextStyle dialogContent = TextStyle(
    fontSize: 16,
    height: 1.5,
    color: AppColors.textPrimary,
  );
  // 弹窗按钮样式
  static const TextStyle dialogAction = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  // SnackBar 内容样式
  static const TextStyle snackBarContent = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

}
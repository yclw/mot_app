import 'package:flutter/material.dart';
import '../../core/themes/app_colors.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // centerTitle: true,
        backgroundColor: AppColors.navBarBackground,
        iconTheme: IconThemeData(color: AppColors.primary),
        title: Text('About',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 20)
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("项目信息"),
            _buildInfoCard(
                children: [
                  _buildInfoItem("课题项目：", "农业大棚监控系统"),
                  _buildInfoItem("软件说明：",
                      "本系统为基于STM32F103C8T6的物联网传感器采集平台，"
                          "采用node.js服务器端与Flutter客户端的交互架构，"
                          "实现数据采集与可视化功能。系统支持实时监控、历史数据查询"
                          "和异常预警等核心功能。")
                ]
            ),

            const SizedBox(height: 24),
            _buildSectionTitle("开发团队"),
            _buildTeamMemberCard(
                children: [
                  _buildMemberInfo("余文哲（3241319113）",
                      "负责STM32嵌入式平台程序设计"),
                  _buildMemberInfo("郑永霖（3241319116）",
                      "负责传感器数据采集与硬件集成"),
                  _buildMemberInfo("王浩璟（3241319117）",
                      "负责服务器与客户端架构开发"),
                ]
            ),

            const SizedBox(height: 24),
            _buildSectionTitle("技术支持"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "系统版本：v0.0.3\n"
                    "更新日期：2025-03-20\n"
                    "github：https://github.com/yclw",
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textTertiary,
                    height: 1.8
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary
          )),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Card(
      elevation: 2,
      color: AppColors.dialogBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.divider, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
            style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                height: 1.5
            ),
            children: [
              TextSpan(
                  text: title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary)
              ),
              TextSpan(text: content)
            ]
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard({required List<Widget> children}) {
    return Card(
      elevation: 2,
      color: AppColors.dialogBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.divider, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildMemberInfo(String name, String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.person_outline,
            color: AppColors.primary),
        title: Text(name,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary
            )),
        subtitle: Text(role,
            style: TextStyle(
                fontSize: 14,
                color: AppColors.textTertiary
            )),
      ),
    );
  }
}
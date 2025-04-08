import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/sensor_data.dart';
import '../../core/services/sensor_api_service.dart';
import '../../core/themes/app_colors.dart';
import '../../core/mock_data/mock_sensor_data.dart';

class EnvironmentMonitorPage extends StatefulWidget {
  const EnvironmentMonitorPage({super.key});

  @override
  State<EnvironmentMonitorPage> createState() => _EnvironmentMonitorPageState();
}

class _EnvironmentMonitorPageState extends State<EnvironmentMonitorPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _startTimer();
  }

  void _initializeData() {
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<SensorApiService>(context, listen: false);

    return FutureBuilder<SensorData?>(
      future: apiService.getLatestMinuteData(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // 加载时显示进度条
        } else if (snapshot.hasError) {
          // 出错时使用虚拟数据并显示错误提示
          final data = MockSensorData.getLatestData();
          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '获取数据失败: ${snapshot.error}，显示模拟数据',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildSensorGrid(context, data),
              ),
            ],
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!;
          return _buildSensorGrid(context, data);
        } else {
          // 没有数据时使用虚拟数据并显示提示
          final data = MockSensorData.getLatestData();
          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.warning),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '未获取到真实数据，显示模拟数据',
                        style: TextStyle(color: AppColors.warning),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildSensorGrid(context, data),
              ),
            ],
          );
        }
      },
    );
  }

  // 提取传感器网格为独立方法以减少重复代码
  Widget _buildSensorGrid(BuildContext context, SensorData data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return GridView.count(
          crossAxisCount: isWide ? 3 : 1, // 根据屏幕宽度显示列数
          childAspectRatio: isWide ? 0.7 : 1.5, // 设置子项的宽高比
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _buildSensorCard(
              context: context,
              icon: Icons.thermostat,
              title: "温度",
              value: "${data.temperature.toStringAsFixed(1)}°C",
              status: _getTemperatureStatus(data.temperature),
            ),
            _buildSensorCard(
              context: context,
              icon: Icons.water_drop,
              title: "湿度",
              value: "${data.humidity.toStringAsFixed(1)}%",
              status: _getHumidityStatus(data.humidity),
            ),
            _buildSensorCard(
              context: context,
              icon: Icons.light_mode,
              title: "光照",
              value: "${data.light.toStringAsFixed(0)} Lux",
              status: _getLightStatus(data.light),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSensorCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Status status,
  }) {
    final statusColor = _getStatusColor(status);

    return Card(
      elevation: 2, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.divider.withAlpha((0.2 * 255).round())),
      ),
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 图标容器
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: statusColor.withAlpha((0.1 * 255).round()),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 16),
            // 标题
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            // 数值显示
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            // 状态指示
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: statusColor.withAlpha((0.3 * 255).round()),
                  width: 1,
                ),
              ),
              child: Text(
                _getStatusText(status),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // 更新状态颜色映射
  Color _getStatusColor(Status status) {
    return switch (status) {
      Status.good => AppColors.success,
      Status.warning => AppColors.warning,
      Status.danger => AppColors.error,
    };
  }

  // 状态判断逻辑
  Status _getTemperatureStatus(double temp) {
    if (temp < 0 || temp > 40) return Status.danger;
    if (temp < 10 || temp > 30) return Status.warning;
    return Status.good;
  }

  Status _getHumidityStatus(double humidity) {
    if (humidity < 20 || humidity > 80) return Status.danger;
    if (humidity < 30 || humidity > 70) return Status.warning;
    return Status.good;
  }

  Status _getLightStatus(double lux) {
    if (lux > 900) return Status.danger;
    if (lux > 700 || lux < 200) return Status.warning;
    return Status.good;
  }

  // 状态文本映射
  String _getStatusText(Status status) {
    return switch (status) {
      Status.good => "正常",
      Status.warning => "警告",
      Status.danger => "危险",
    };
  }
}

enum Status { good, warning, danger }

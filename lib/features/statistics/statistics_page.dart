import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/models/sensor_data.dart';
import '../../core/services/sensor_api_service.dart';
import '../../core/themes/app_colors.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _selectedPeriod = '24h';
  final Map<String, bool> _selectedParameters = {
    'temperature': true,
    'humidity': false,
    'light': false,
  };
  
  List<SensorData> _sensorData = [];
  bool _isLoading = false;
  String? _errorMessage;

  final Map<String, dynamic> _periodOptions = {
    '24h': {'label': '过去24小时', 'type': 'hours'},
    '7d': {'label': '过去7天', 'days': 7},
    '30d': {'label': '过去30天', 'days': 30},
    '1m': {'label': '过去1个月', 'months': 1},
    '2m': {'label': '过去2个月', 'months': 2},
    '3m': {'label': '过去3个月', 'months': 3},
  };

  Future<void> _fetchData() async {
    if (!_selectedParameters.containsValue(true)) {
      setState(() => _errorMessage = '请至少选择一个分析参数');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = Provider.of<SensorApiService>(context, listen: false);
      List<SensorData> data;

      switch (_selectedPeriod) {
        case '24h':
          data = await apiService.getHourlyLast24h();
          break;
        case '7d':
        case '30d':
          data = await apiService.getHourlyPastDays(_periodOptions[_selectedPeriod]['days']);
          break;
        default:
          data = await apiService.getHourlyPastMonths(_periodOptions[_selectedPeriod]['months']);
      }

      data.sort((a, b) => a.datetime.compareTo(b.datetime));

      setState(() => _sensorData = data);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<LineSeries<SensorData, DateTime>> _buildSeries() {
    final Map<String, Color> colors = {
      'temperature': AppColors.primary,
      'humidity': AppColors.secondary,
      'light': AppColors.success,
    };

    final List<LineSeries<SensorData, DateTime>> series = [];
    _selectedParameters.forEach((key, selected) {
      if (selected) {
        series.add(LineSeries<SensorData, DateTime>(
          dataSource: _sensorData,
          xValueMapper: (data, _) => data.datetime,
          yValueMapper: (data, _) {
            switch (key) {
              case 'temperature':
                return data.temperature;
              case 'humidity':
                return data.humidity;
              case 'light':
                return data.light;
              default:
                return null;
            }
          },
          name: _getParameterLabel(key),
          color: colors[key],
          markerSettings: MarkerSettings(isVisible: true),
          enableTooltip: true,
          animationDuration: 800,
        ));
      }
    });

    return series;
  }

  String _getParameterLabel(String key) {
    switch (key) {
      case 'temperature':
        return '温度(℃)';
      case 'humidity':
        return '湿度(%)';
      case 'light':
        return '光照(lx)';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPeriod,
                    items: _periodOptions.keys.map((key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(
                          _periodOptions[key]['label'],
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedPeriod = value!),
                    decoration: InputDecoration(
                      labelText: '时间范围',
                      labelStyle: TextStyle(color: AppColors.textPrimary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    dropdownColor: AppColors.background,
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.refresh, color: AppColors.textTertiary),
                  label: Text('查询'),
                  onPressed: _isLoading ? null : _fetchData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textQuaternary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              children: _selectedParameters.keys.map((key) {
                return FilterChip(
                  label: Text(
                    _getParameterLabel(key),
                    style: TextStyle(
                      color: _selectedParameters.containsValue(true) ? AppColors.textQuaternary : AppColors.textPrimary,
                    ),
                  ),
                  selected: _selectedParameters[key]!,
                  onSelected: (selected) => setState(() => _selectedParameters[key] = selected),
                  backgroundColor: _withCustomAlpha(AppColors.secondary,100),
                  selectedColor: AppColors.primary,
                  surfaceTintColor: AppColors.primary,
                  shadowColor: AppColors.primary,
                  selectedShadowColor: AppColors.primary,
                  side: BorderSide.none,
                  checkmarkColor: AppColors.textTertiary,
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _buildChartContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContent() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          '错误: $_errorMessage',
          style: TextStyle(color: AppColors.error),
        ),
      );
    }

    if (_sensorData.isEmpty) {
      return Center(
        child: Text(
          '选择参数后点击查询获取数据',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: TextStyle(color: AppColors.textPrimary),
      ),
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(
          text: '时间',
          textStyle: TextStyle(color: AppColors.textPrimary),
        ),
        intervalType: _selectedPeriod == '24h'
            ? DateTimeIntervalType.hours
            : DateTimeIntervalType.days,
        dateFormat: _selectedPeriod == '24h'
            ? DateFormat.Hm()
            : DateFormat.MMMd(),
        labelStyle: TextStyle(color: AppColors.textPrimary),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: '数值',
          textStyle: TextStyle(color: AppColors.textPrimary),
        ),
        labelStyle: TextStyle(color: AppColors.textPrimary),
      ),
      series: _buildSeries(),
    );
  }


  Color _withCustomAlpha(Color color, int alpha) {
    return Color.fromARGB(
      alpha.clamp(0, 255),
      (color.r * 255.0).toInt(),
      (color.g * 255.0).toInt(),
      (color.b * 255.0).toInt(),
    );
  }
}

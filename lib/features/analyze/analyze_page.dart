import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/sensor_data.dart';
import '../../core/services/sensor_api_service.dart';
import '../../core/themes/app_colors.dart';
import '../settings/settings_model.dart';
import './uitl/deepseek_api_service.dart';

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Map<String, dynamic>> mockData = [
    {'id': '1', 'name': '过去24小时数据', 'data': ''},
    {'id': '2', 'name': '过去7天数据', 'data': ''},
    {'id': '3', 'name': '当前数据', 'data': ''},
    {'id': '4', 'name': '不携带数据，询问有关农业的相关问题', 'data': ''},
  ];

  String? selectedDataId;
  String analysisResult = '';
  bool isLoading = false;
  String errorMessage = '';
  final TextEditingController descriptionController = TextEditingController();

  // 获取数据
  Future<void> fetchData() async {
    if (selectedDataId == null) {
      setState(() => errorMessage = '请先选择数据');
      return;
    }
    String dataString = '';

    try {
      final apiService = Provider.of<SensorApiService>(context, listen: false);
      List<SensorData> data;

      switch (selectedDataId) {
        case '1':
          data = await apiService.getHourlyLast24h();
          break;
        case '2':
          data = await apiService.getHourlyPastDays(7);
          break;
        case '3':
          SensorData? nowData = await apiService.getLatestMinuteData();
          data = [nowData!];
          break;
        default:
          SensorData? nowData = await apiService.getLatestMinuteData();
          data = [nowData!];
      }
      data.sort((a, b) => a.datetime.compareTo(b.datetime));
      dataString = data.map((item) {
        return '${item.datetime.toIso8601String()},${item.temperature},${item.humidity},${item.light}';
      }).join('\n');
    } catch (e) {
      setState(() => errorMessage = '获取数据失败: ${e.toString()}');
    } finally {
      if (dataString.isNotEmpty) {
        mockData.firstWhere((data) => data['id'] == selectedDataId)['data'] =
            dataString;
      }
    }
  }

  Future<void> analyzeData(String? apiKey) async {
    selectedDataId ??= mockData.firstWhere((data) => data['name'] == '不携带数据，询问有关农业的相关问题')['id'];
    if (descriptionController.text.isEmpty) {
      descriptionController.text = '无';
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      analysisResult = '';
    });

    await fetchData();

    try {
      final selectedData =
      mockData.firstWhere((data) => data['id'] == selectedDataId);
      String dataString =
          '${selectedData['name'] ?? ''}:${selectedData['data'] ?? ''}';


      if (apiKey == null) {
        setState(() => errorMessage = '请先设置API Key');
        return;
      }

      final result = await DeepSeekService.analyzeData(
        dataString,
        descriptionController.text,
        apiKey
      );

      setState(() => analysisResult = result);
    } catch (e) {
      print("analyzeData error: ${e.toString()}");
      setState(() => errorMessage = '分析失败: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? apiKey = Provider.of<SettingsModel>(context).apiKey;
    super.build(context);
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 下拉选择数据
            DropdownButtonFormField<String>(
              value: selectedDataId,
              decoration: InputDecoration(
                labelText: '选择大棚数据',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              dropdownColor: AppColors.background,
              items: mockData
                  .map((data) => DropdownMenuItem<String>(
                value: data['id'],
                child: Text(
                  data['name'],
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ))
                  .toList(),
              onChanged: (value) => setState(() => selectedDataId = value),
            ),
            const SizedBox(height: 20),
            // 输入描述
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: '补充信息',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                hintText: '请输入内容...',
                hintStyle: TextStyle(color: AppColors.textTertiary),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // 开始分析按钮
            ElevatedButton.icon(
              icon: isLoading
                  ? const SizedBox.shrink()
                  : const Icon(Icons.analytics, color: AppColors.textTertiary),
              label: isLoading
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('开始分析'),
              onPressed: isLoading ? null : () async => await analyzeData(apiKey),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textQuaternary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 20),
            // 错误提示
            if (errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            // 分析结果
            if (analysisResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  analysisResult,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

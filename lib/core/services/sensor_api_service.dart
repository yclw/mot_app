import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/sensor_data.dart';
import '../mock_data/mock_sensor_data.dart';

class SensorApiService {
  final http.Client client;
  bool useMockData; // 是否使用模拟数据的标志

  SensorApiService({
    required this.client, 
    this.useMockData = false, // 默认不使用模拟数据
  });

  Future<SensorData?> getLatestMinuteData() async {
    // 使用模拟数据时直接返回
    if (useMockData) {
      return MockSensorData.getLatestData();
    }

    try {
      final response = await client
          .get(Uri.parse('${ApiConfig.baseUrl}/api/latest-minute'))
          .timeout(ApiConfig.receiveTimeout);
  
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData.isEmpty ? null : SensorData.fromJson(jsonData);
      }
      throw _handleError(response.statusCode);
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<List<SensorData>> getHourlyLast24h() async {
    // 使用模拟数据时直接返回
    if (useMockData) {
      return MockSensorData.getLast24Hours();
    }
    return _fetchData('${ApiConfig.baseUrl}/api/hourly-last-24h');
  }

  Future<List<SensorData>> getHourlyPastDays(int days) async {
    // 使用模拟数据时直接返回
    if (useMockData) {
      return MockSensorData.getPastDays(days);
    }
    return _fetchData(
      '${ApiConfig.baseUrl}/api/hourly-past-days?days=$days',
    );
  }

  Future<List<SensorData>> getHourlyPastMonths(int months) async {
    // 使用模拟数据时直接返回
    if (useMockData) {
      return MockSensorData.getPastMonths(months);
    }
    return _fetchData(
      '${ApiConfig.baseUrl}/api/hourly-past-months?months=$months',
    );
  }

  Future<List<SensorData>> _fetchData(String url) async {
    try {
      final response = await client
          .get(Uri.parse(url))
          .timeout(ApiConfig.receiveTimeout);
      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => SensorData.fromJson(e)).toList();
      }
      throw _handleError(response.statusCode);
    } catch (e) {
      throw _handleException(e);
    }
  }

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request';
      case 404:
        return 'Data not found';
      case 500:
        return 'Server error';
      default:
        return 'Request failed with status: $statusCode';
    }
  }

  String _handleException(dynamic error) {
    if (error is String) return error;
    return 'Network request failed: ${error.toString()}';
  }
}
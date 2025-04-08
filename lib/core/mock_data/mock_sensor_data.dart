import '../../core/models/sensor_data.dart';
import 'dart:math' as math;

class MockSensorData {
  // 获取最新的模拟数据
  static SensorData getLatestData() {
    return SensorData(
      id: 1000,
      datetime: DateTime.now(),
      temperature: 22.5,
      humidity: 55.0,
      light: 450.0,
    );
  }

  // 获取过去24小时的模拟数据
  static List<SensorData> getLast24Hours() {
    final now = DateTime.now();
    final List<SensorData> data = [];
    
    for (int i = 0; i < 24; i++) {
      data.add(
        SensorData(
          id: 1000 - i,
          datetime: now.subtract(Duration(hours: i)),
          temperature: 20.0 + _randomVariation(5.0),
          humidity: 50.0 + _randomVariation(10.0),
          light: 400.0 + _randomVariation(200.0),
        ),
      );
    }
    
    return data;
  }

  // 获取过去几天的模拟数据
  static List<SensorData> getPastDays(int days) {
    final now = DateTime.now();
    final List<SensorData> data = [];
    
    for (int i = 0; i < days * 24; i++) {
      // 每小时一条数据
      if (i % 3 == 0) { // 简化为8条/天
        data.add(
          SensorData(
            id: 1000 - i,
            datetime: now.subtract(Duration(hours: i)),
            temperature: 20.0 + _randomVariation(8.0) + _dayCycle(i % 24),
            humidity: 50.0 + _randomVariation(15.0) - _dayCycle(i % 24),
            light: _getLightByHour(i % 24) + _randomVariation(100.0),
          ),
        );
      }
    }
    
    return data;
  }

  // 获取过去几个月的模拟数据
  static List<SensorData> getPastMonths(int months) {
    final now = DateTime.now();
    final List<SensorData> data = [];
    final daysInPeriod = months * 30; // 近似值
    
    for (int i = 0; i < daysInPeriod; i++) {
      // 每天一条数据
      data.add(
        SensorData(
          id: 1000 - i,
          datetime: now.subtract(Duration(days: i)),
          temperature: 20.0 + _seasonalVariation(i, months) + _randomVariation(3.0),
          humidity: 50.0 - _seasonalVariation(i, months) * 2 + _randomVariation(5.0),
          light: 400.0 + _seasonalVariation(i, months) * 50 + _randomVariation(50.0),
        ),
      );
    }
    
    return data;
  }

  // 生成随机变化
  static double _randomVariation(double maxVariation) {
    return (DateTime.now().microsecondsSinceEpoch % 1000) / 1000 * maxVariation - maxVariation / 2;
  }

  // 根据一天中的小时模拟昼夜温度变化
  static double _dayCycle(int hourOfDay) {
    // 最高温在下午2点(14时)，最低温在凌晨4点(4时)
    return 3.0 * math.sin((hourOfDay - 4) * math.pi / 12);
  }

  // 根据小时模拟光照变化
  static double _getLightByHour(int hour) {
    if (hour >= 6 && hour < 18) { // 白天
      // 中午12点光照最强
      double peakFactor = 1.0 - (hour - 12).abs() / 6.0;
      return 600.0 * peakFactor + 50.0;
    } else { // 夜间
      return 5.0 + _randomVariation(10.0); // 夜间低光照
    }
  }

  // 模拟季节变化
  static double _seasonalVariation(int daysPast, int monthsTotal) {
    // 假设开始是夏季，温度从高到低再到高
    final periodInDays = monthsTotal * 30;
    final position = daysPast / periodInDays; // 0到1之间的相对位置
    
    // 正弦波形模拟温度季节性变化
    return 10.0 * math.sin(position * 2 * math.pi);
  }
} 
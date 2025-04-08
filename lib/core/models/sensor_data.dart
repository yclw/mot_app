class SensorData {
  final int id;
  final DateTime datetime;
  final double temperature;
  final double humidity;
  final double light;

  SensorData({
    required this.id,
    required this.datetime,
    required this.temperature,
    required this.humidity,
    required this.light,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'] as int,
      datetime: DateTime.parse(json['datetime'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      light: (json['light'] as num).toDouble(),
    );
  }

  // 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'datetime': datetime.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
      'light': light,
    };
  }
}
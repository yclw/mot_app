// settings_model.dart - 状态管理
import '/features/settings/settings_service.dart';
import 'package:flutter/foundation.dart';
import '/core/config/api_config.dart';

class SettingsModel with ChangeNotifier {
  final SettingsService _service = SettingsService();

  String? _apiKey;
  String? _serverAddress;

  String? get apiKey => _apiKey;
  String? get serverAddress => _serverAddress;

  Future<void> loadSettings() async {
    _apiKey = await _service.getApiKey();
    _serverAddress = await _service.getServerAddress();
    
    // 在加载设置时更新ApiConfig
    ApiConfig.updateBaseUrl(_serverAddress);
    
    notifyListeners();
  }

  Future<void> updateSettings({String? apiKey, String? serverAddr}) async {
    await _service.saveSettings(apiKey, serverAddr);
    
    if (apiKey != null) {
      _apiKey = apiKey;
    }
    
    if (serverAddr != null) {
      _serverAddress = serverAddr;
      // 只有在服务器地址更新时才更新 ApiConfig
      ApiConfig.updateBaseUrl(_serverAddress);
    }
    
    notifyListeners();
  }
}
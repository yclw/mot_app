// settings_service.dart - 存储服务类
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _apiKeyKey = 'DEEPSEEK_API_KEY';
  static const _serverAddrKey = 'SERVER_ADDRESS';

  Future<void> saveSettings(String? apiKey, String? serverAddr) async {
    final prefs = await SharedPreferences.getInstance();
    if (apiKey != null) {
      await prefs.setString(_apiKeyKey, apiKey);
    }
    if (serverAddr != null) {
      await prefs.setString(_serverAddrKey, serverAddr);
    }
  }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }

  Future<String?> getServerAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_serverAddrKey);
  }
}
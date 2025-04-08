class ApiConfig {
  static String baseUrl = '';
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration connectTimeout = Duration(seconds: 15);
  
  static void updateBaseUrl(String? serverAddress) {
    if (serverAddress != null && serverAddress.isNotEmpty) {
      baseUrl = serverAddress;
    } else {
      baseUrl = 'http://117.72.118.76:3000';
    }
  }
}
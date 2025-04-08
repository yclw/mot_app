import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'core/services/sensor_api_service.dart';
import 'core/themes/app_theme.dart';
import 'features/about/about_page.dart';
import 'features/feedback/feedback_page.dart';
import 'features/home/home_page.dart';
import 'features/settings/settings_model.dart';
import 'features/settings/settings_page.dart';
import 'package:provider/provider.dart';
import 'core/config/api_config.dart';

// 是否使用模拟数据，在调试时可以设置为true
const bool USE_MOCK_DATA = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsModel = SettingsModel();
  await settingsModel.loadSettings();
  
  // 使用设置的serverAddress更新ApiConfig
  ApiConfig.updateBaseUrl(settingsModel.serverAddress);
  
  runApp(
    MultiProvider(
      providers: [
        Provider<SensorApiService>(
          create: (_) => SensorApiService(
            client: http.Client(),
            useMockData: USE_MOCK_DATA, // 设置是否使用模拟数据
          ),
        ),
        ChangeNotifierProvider(create: (_) => settingsModel),   
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomePage(title: '210 monitor system',),
      routes: {
        '/settings': (context) => SettingsPage(),
        '/home': (context) => HomePage(title: 'dsp',),
        '/about': (context) => AboutPage(),
        '/feedback': (context) => FeedbackPage(),
      },
    );
  }
}

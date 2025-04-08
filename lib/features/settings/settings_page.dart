// settings_screen.dart - 设置界面
import '/features/settings/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/themes/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _apiKeyController;
  late final TextEditingController _serverController;

  @override
  void initState() {
    super.initState();
    final model = Provider.of<SettingsModel>(context, listen: false);
    _apiKeyController = TextEditingController(text: model.apiKey);
    _serverController = TextEditingController(text: model.serverAddress);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.navBarBackground,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      body: Container(
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // API Key输入框
                TextFormField(
                  controller: _apiKeyController,
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'DeepSeek API Key',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textTertiary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.error),
                    ),
                    errorStyle: TextStyle(color: AppColors.error),
                  ),
                  validator: null,
                ),

                const SizedBox(height: 20),

                // 服务器地址输入框
                TextFormField(
                  controller: _serverController,
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Server Address',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintText: '例:http://127.0.0.1:8080',
                    hintStyle: TextStyle(color: AppColors.textTertiary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.error),
                    ),
                    errorStyle: TextStyle(color: AppColors.error),
                  ),
                  keyboardType: TextInputType.url,
                  validator: null,
                ),

                const SizedBox(height: 30),

                // 保存按钮
                ElevatedButton.icon(
                  icon: const Icon(Icons.analytics, color: AppColors.textTertiary),
                  label: const Text('保存设置'),
                  onPressed: _saveSettings,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      String? apiKey = _apiKeyController.text.trim();
      if (apiKey.isEmpty) apiKey = null;
      
      String? serverAddr = _serverController.text.trim();
      if (serverAddr.isEmpty) serverAddr = null;
      
      await Provider.of<SettingsModel>(context, listen: false).updateSettings(
        apiKey: apiKey,
        serverAddr: serverAddr,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Settings saved successfully!',
              style: TextStyle(color: AppColors.textPrimary)),
          backgroundColor: AppColors.snackBarBackground,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AppColors.divider),
          ),
        ),
      );
    }
  }
}
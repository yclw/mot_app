// deepseek_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
class DeepSeekService {
  
  static const String _apiUrl = 'https://api.deepseek.com/chat/completions';

  static Future<String> analyzeData(String data, String description, String apiKey) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'model': 'deepseek-chat',
        'messages': [
          {
            'role': 'system',
            'content': '你是一个农业专家\n'
          },
          {'role': 'user', 'content': '请根据以下大棚环境监测数据进行分析：\n'
              '$data\n'
              '补充描述：$description\n'
              '请用中文给出专业分析建议'
          }
        ],
        "frequency_penalty": 0,
        "max_tokens": 2048,
        "presence_penalty": 0,
        "response_format": {
          "type": "text"
        },
        "stop": null,
        "stream": false,
        "stream_options": null,
        "temperature": 1,
        "top_p": 1,
        "tools": null,
        "tool_choice": "none",
        "logprobs": false,
        "top_logprobs": null
      }),
    );
    if (response.statusCode == 200) {
      final utf8String = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(utf8String);
      return responseData['choices'][0]['message']['content'];
    } else {
      throw Exception('API请求失败: ${response.statusCode}');
    }
  }
}
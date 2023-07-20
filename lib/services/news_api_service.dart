import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  final String _baseUrl = 'https://newsapi.org/v2/';
  final String _apiKey = 'e957b648fcbe4c638bc033464f6128b0';

  Future<Map<String, dynamic>> _get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchLatestNews() async {
    try {
      final Map<String, dynamic> data =
          await _get('top-headlines?country=us&apiKey=$_apiKey');
      if (data['status'] == 'ok') {
        return List<Map<String, dynamic>>.from(data['articles']);
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      throw Exception('Failed to fetch news');
    }
  }
}

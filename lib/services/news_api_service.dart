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
          await _get('top-headlines?country=in&apiKey=$_apiKey');
      if (data['status'] == 'ok') {
        List<Map<String, dynamic>> articles =
            List<Map<String, dynamic>>.from(data['articles']);
        articles = articles.take(100).toList();
        return articles;
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      throw Exception('Failed to fetch news');
    }
  }

  // Add a new method to search news by keyword
  Future<List<Map<String, dynamic>>> searchNewsByKeyword(String keyword) async {
    try {
      final Map<String, dynamic> data =
          await _get('everything?q=$keyword&apiKey=$_apiKey');
      if (data['status'] == 'ok') {
        List<Map<String, dynamic>> articles =
            List<Map<String, dynamic>>.from(data['articles']);
        articles = articles.take(100).toList();
        return articles;
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      throw Exception('Failed to search news');
    }
  }
}

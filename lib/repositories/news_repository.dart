import '../models/news_model.dart';
import '../services/news_api_service.dart';

class NewsRepository {
  final NewsApiService _apiService = NewsApiService();

  Future<List<NewsModel>> fetchLatestNews() async {
    try {
      final List<Map<String, dynamic>> newsData =
          await _apiService.fetchLatestNews();
      return newsData.map((json) => NewsModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch news');
    }
  }

  Future<List<NewsModel>> fetchNewsByKeyword(String keyword) async {
    try {
      final List<Map<String, dynamic>> newsData =
          await _apiService.searchNewsByKeyword(keyword);
      return newsData.map((json) => NewsModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch news');
    }
  }
}

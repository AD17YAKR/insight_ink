import 'package:get/get.dart';
import '../models/news_model.dart';
import '../repositories/news_repository.dart';
import '../state/news_state.dart';

class NewsViewModel extends GetxController {
  final NewsRepository _newsRepository = NewsRepository();

  final _newsList = <NewsModel>[].obs;
  final _newsState = NewsState.loading.obs;
  final _errorMessage = ''.obs;

  List<NewsModel> get newsList => _newsList;
  NewsState get newsState => _newsState.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    fetchLatestNews();
    super.onInit();
  }

  Future<void> fetchLatestNews() async {
    try {
      _newsState.value = NewsState.loading;
      _errorMessage.value = '';

      final newsData = await _newsRepository.fetchLatestNews();
      _newsList.assignAll(newsData);

      _newsState.value = NewsState.loaded;
    } catch (e) {
      _errorMessage.value = e.toString();
      _newsState.value = NewsState.error;
    }
  }
}

import 'package:get/get.dart';
import '../models/news_model.dart';
import '../repositories/news_repository.dart';
import '../state/news_state.dart';

class NewsViewModel extends GetxController {
  final NewsRepository _newsRepository = NewsRepository();

  final _newsList = <NewsModel>[].obs;
  final _newsState = NewsState.loading.obs;
  final _errorMessage = ''.obs;
  final _sortBy = RxString('Chronological');
  final _isCarouselMode = false.obs;

  List<NewsModel> get sortedNewsList {
    switch (_sortBy.value) {
      case 'Reverse':
        return _newsList.reversed.toList();
      default:
        return _newsList;
    }
  }

  List<NewsModel> get newsList => _newsList;
  NewsState get newsState => _newsState.value;
  String get errorMessage => _errorMessage.value;
  String get sortBy => _sortBy.value;
  bool get isCarouselMode => _isCarouselMode.value;

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

  Future<void> fetchNewsByKeyword(String keyword) async {
    try {
      _newsState.value = NewsState.loading;
      _errorMessage.value = '';

      final newsData = await _newsRepository.fetchNewsByKeyword(keyword);
      _newsList.assignAll(newsData);

      _newsState.value = NewsState.loaded;
    } catch (e) {
      _errorMessage.value = e.toString();
      _newsState.value = NewsState.error;
    }
  }

  void onSortByChanged(String? value) {
    if (value != null) {
      _sortBy.value = value;
      update();
    }
  }

  void toggleCarouselMode() {
    _isCarouselMode.toggle();
    update();
  }

  final RxBool isSearchActive = false.obs;
  final RxString _searchQuery = ''.obs;

  List<NewsModel> get filteredNewsList {
    if (isSearchActive.value && _searchQuery.isNotEmpty) {
      return _newsList.where((news) {
        return news.title
            .toLowerCase()
            .contains(_searchQuery.value.toLowerCase());
      }).toList();
    } else {
      return _newsList;
    }
  }

  void onSearchTextChanged(String query) {
    _searchQuery.value = query.trim();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../state/news_state.dart';
import '../view_models/news_view_model.dart';
import '../models/news_model.dart';

class HomeScreen extends StatelessWidget {
  final NewsViewModel _newsViewModel = Get.put(NewsViewModel());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
        actions: [
          _buildSortDropdown(),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              switch (_newsViewModel.newsState) {
                case NewsState.loading:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(10, 23, 46, 1.0),
                    ),
                  );
                case NewsState.loaded:
                  return _buildNewsList(context);
                case NewsState.error:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _newsViewModel.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                        ElevatedButton(
                          onPressed: () => _newsViewModel.fetchLatestNews(),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                default:
                  return const Center(child: Text('Unknown state'));
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      margin: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search News or Keyword',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _clearSearch();
              _searchNews();
            },
          ),
        ),
        onChanged: _newsViewModel.onSearchTextChanged,
        onSubmitted: (_) {
          _searchNews();
        },
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    _newsViewModel.onSearchTextChanged('');
  }

  void _searchNews() {
    String keyword = _searchController.text;
    if (keyword.isNotEmpty) {
      _newsViewModel.fetchNewsByKeyword(keyword);
    } else {
      _newsViewModel.fetchLatestNews();
    }
  }

  Widget _buildNewsItem(BuildContext context, NewsModel news) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          Get.toNamed('/news_detail', arguments: news);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news.imageUrl != null && news.imageUrl!.isNotEmpty)
                Hero(
                  tag: news.imageUrl!,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      news.imageUrl!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                news.title,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8),
              Text(
                news.description,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 8),
              Text(
                'Author: ${news.author}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 8),
              Text(
                'Published on: ${DateFormat('dd-MM-yyyy hh:mm a').format(news.date)}',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _newsViewModel.sortBy,
            icon: const Icon(Icons.filter_list, size: 28, color: Colors.white),
            elevation: 8,
            dropdownColor: Colors.blueGrey[900],
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            items: <String>[
              'Chronological',
              'Reverse',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              _newsViewModel.onSortByChanged(newValue);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNewsList(BuildContext context) {
    return ListView.builder(
      itemCount: _newsViewModel.sortedNewsList.length,
      itemBuilder: (context, index) {
        NewsModel news = _newsViewModel.sortedNewsList[index];
        return _buildNewsItem(context, news);
      },
    );
  }
}

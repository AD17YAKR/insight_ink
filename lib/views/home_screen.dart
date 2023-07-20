import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../state/news_state.dart';
import '../view_models/news_view_model.dart';
import '../models/news_model.dart';

class HomeScreen extends StatelessWidget {
  final NewsViewModel _newsViewModel = Get.find<NewsViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest News'),
      ),
      body: Obx(
        () {
          switch (_newsViewModel.newsState) {
            case NewsState.loading:
              return Center(child: CircularProgressIndicator());
            case NewsState.loaded:
              return ListView.builder(
                itemCount: _newsViewModel.newsList.length,
                itemBuilder: (context, index) {
                  NewsModel news = _newsViewModel.newsList[index];
                  return _buildNewsItem(news);
                },
              );
            case NewsState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _newsViewModel.errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () => _newsViewModel.fetchLatestNews(),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            default:
              return Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildNewsItem(NewsModel news) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          // TODO: Implement navigation to the news detail page.
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news.imageUrl != null)
                Image.network(
                  news.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 8),
              Text(
                news.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                news.description,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Author: ${news.author}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Published on: ${_formatDate(news.date)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}

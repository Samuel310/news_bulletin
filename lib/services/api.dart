import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:news_bulletin/models/source.dart';
import 'package:news_bulletin/models/top-headlines.dart';
import 'package:news_bulletin/services/app.intercepter.dart';

NewsApiRepo apiRepo = NewsApiRepo();

class NewsApiRepo {
  final Dio _dio = new Dio();

  final String apiKey = 'c9e9b0c321d645d7aa25cce9e99a1e7c';

  NewsApiRepo() {
    _dio.options.baseUrl = 'https://newsapi.org/v2';
    _dio.interceptors.add(DioInterceptor());
  }

  Future<TopHeadlines> getTopHeadlines({String country, String category, int page}) async {
    Map<String, dynamic> queryParams = {
      "country": country,
      "page": page,
      "pageSize": "10",
      "apiKey": apiKey,
    };

    if (category != null) {
      queryParams['category'] = category;
    }

    Response response = await _dio.get('/top-headlines', queryParameters: queryParams);

    return topHeadlinesFromJson(response.data);
  }

  Future<TopHeadlines> searchArticles({@required String searchQuery, @required int page}) async {
    Map<String, dynamic> queryParams = {
      "q": searchQuery,
      "sortBy": "publishedAt",
      "page": page,
      "pageSize": "10",
      "language": "en",
      "apiKey": apiKey,
    };
    print("queryParams " + queryParams.toString());
    Response response = await _dio.get('/everything', queryParameters: queryParams);

    return topHeadlinesFromJson(response.data);
  }

  Future<Sources> getAllSources() async {
    Map<String, dynamic> queryParams = {
      "language": "en",
      "apiKey": apiKey,
    };
    print("queryParams " + queryParams.toString());
    Response response = await _dio.get('/sources', queryParameters: queryParams);

    return sourcesFromJson(response.data);
  }
}

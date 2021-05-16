import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_bulletin/models/top-headlines.dart';
import 'package:news_bulletin/services/api.dart';

Future<List<News>> _getNotificationDataFromServer({int page, String searchQuery}) async {
  try {
    TopHeadlines topHeadlines = await apiRepo.searchArticles(page: page, searchQuery: searchQuery);
    return topHeadlines.news;
  } catch (e) {
    return Future.error(e);
  }
}

class SearchArticleService {
  Stream<List<News>> stream;
  bool hasMore;
  BuildContext context;
  bool _isLoading;
  List<News> _data;
  StreamController<List<News>> _controller;

  bool initialCall;
  int page;

  SearchArticleService({this.context}) {
    _data = List<News>.empty(growable: true);
    _controller = StreamController<List<News>>.broadcast();
    _isLoading = false;
    stream = _controller.stream.map((List<News> postsData) {
      return postsData;
    });
    hasMore = true;
    page = 1;
    initialCall = true;
    //refresh();
  }

  Future<void> refresh({String searchQuery}) {
    return loadMore(clearCachedData: true, searchQuery: searchQuery);
  }

  Future<void> loadMore({bool clearCachedData = false, @required String searchQuery}) {
    print("called");
    if (clearCachedData) {
      _data = List<News>.empty(growable: true);
      _controller.add(_data);
      hasMore = true;
      page = 1;
    }
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    print("came here 2");
    return _getNotificationDataFromServer(page: this.page++, searchQuery: searchQuery).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      hasMore = postsData != null && postsData.length != 0;
      _controller.add(_data);
      if (this.initialCall) {
        this.initialCall = false;
        loadMore(searchQuery: searchQuery);
      }
    }).catchError((e) {
      _isLoading = false;
      _controller.addError(e);
      return null;
    });
  }
}

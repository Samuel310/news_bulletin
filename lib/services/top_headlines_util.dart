import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_bulletin/models/top-headlines.dart';
import 'package:news_bulletin/services/api.dart';

Future<List<News>> _getNotificationDataFromServer({int page, String country, String category}) async {
  try {
    TopHeadlines topHeadlines = await apiRepo.getTopHeadlines(page: page, country: country, category: category);
    return topHeadlines.news;
  } catch (e) {
    return Future.error(e);
  }
}

class TopHeadlineService {
  Stream<List<News>> stream;
  bool hasMore;
  BuildContext context;
  bool _isLoading;
  List<News> _data;
  StreamController<List<News>> _controller;

  bool initialCall;
  int page;

  TopHeadlineService({this.context}) {
    _data = List<News>.empty(growable: true);
    _controller = StreamController<List<News>>.broadcast();
    _isLoading = false;
    stream = _controller.stream.map((List<News> postsData) {
      return postsData;
    });
    hasMore = true;
    page = 1;
    initialCall = true;
    refresh();
  }

  Future<void> refresh({String category}) {
    return loadMore(clearCachedData: true, category: category);
  }

  Future<void> loadMore({bool clearCachedData = false, String country = "in", @required String category}) {
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
    return _getNotificationDataFromServer(page: this.page++, category: category, country: country).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      hasMore = postsData != null && postsData.length != 0;
      _controller.add(_data);
      if (this.initialCall) {
        this.initialCall = false;
        loadMore(category: category);
      }
    }).catchError((e) {
      _isLoading = false;
      _controller.addError(e);
      return null;
    });
  }
}

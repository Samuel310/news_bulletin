import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_bulletin/common/widgets/news_tile.dart';
import 'package:news_bulletin/common/widgets/loader.dart';
import 'package:news_bulletin/models/top-headlines.dart';
import 'package:news_bulletin/services/search_articles_util.dart';
import 'package:news_bulletin/services/top_headlines_util.dart';

class NewsBuilder extends StatelessWidget {
  final Function onRefresh;
  final Stream<List<News>> stream;
  final ScrollController scrollController;
  final dynamic service;
  NewsBuilder({
    @required this.onRefresh,
    @required this.stream,
    @required this.scrollController,
    @required this.service,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        print("snapshot.hasData : ${snapshot.hasData}");
        if (snapshot.hasData) {
          List<News> notificationList = snapshot.data;
          if (notificationList.isEmpty) {
            return Center(child: initialLoader);
          } else {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: Scrollbar(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: notificationList.length + 1,
                  itemBuilder: (context, index) {
                    if (index < notificationList.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15 / 2),
                        child: NewsTile(newsModel: notificationList[index]),
                      );
                    } else if ((service is TopHeadlineService || service is SearchArticleService) && service.hasMore) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: newsLoader,
                        ),
                      );
                    } else {
                      return Visibility(visible: false, child: Text("Reached end"));
                    }
                  },
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          String errorMsg = '';
          if (snapshot.error is DioError) {
            DioError e = snapshot.error;
            print(e.response.data["message"]);
            errorMsg = e.response.data["message"];
          } else {
            print(snapshot.error.toString());
            errorMsg = snapshot.error.toString();
          }
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(errorMsg, textAlign: TextAlign.center),
            ),
          );
        } else {
          return Center(
            child: service is TopHeadlineService ? initialLoader : Image(image: AssetImage("assets/images/news2.png"), width: 60),
          );
        }
      },
    );
  }
}

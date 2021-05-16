import 'package:flutter/material.dart';
import 'package:news_bulletin/common/widgets/news_builder.dart';
import 'package:news_bulletin/services/search_articles_util.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ScrollController scrollController = ScrollController();
  SearchArticleService topHeadlineService;

  TextEditingController searchQueryController = TextEditingController();

  @override
  void initState() {
    topHeadlineService = SearchArticleService(context: context);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        topHeadlineService.loadMore(searchQuery: searchQueryController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          //color: Colors.grey[900],
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: searchQueryController,
                          //cursorColor: Colors.black,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 25, bottom: 11, top: 11, right: 15),
                            hintText: "Search any topics",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              child: SizedBox(height: 40, width: 40, child: Icon(Icons.search)),
                              onTap: () async {
                                print("searchQueryController " + searchQueryController.text);
                                if (searchQueryController.text.isNotEmpty) {
                                  await topHeadlineService.refresh(searchQuery: searchQueryController.text);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: NewsBuilder(
                  onRefresh: () {
                    return topHeadlineService.refresh(searchQuery: searchQueryController.text);
                  },
                  stream: topHeadlineService.stream,
                  scrollController: scrollController,
                  service: topHeadlineService,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

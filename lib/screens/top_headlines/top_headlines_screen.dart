import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_bulletin/common/widgets/news_builder.dart';
import 'package:news_bulletin/config.dart';
import 'package:news_bulletin/screens/top_headlines/widgets/animated_drawer.dart';
import 'package:news_bulletin/services/top_headlines_util.dart';

class TopHeadlinesScreen extends StatefulWidget {
  @override
  _TopHeadlinesScreenState createState() => _TopHeadlinesScreenState();
}

class _TopHeadlinesScreenState extends State<TopHeadlinesScreen> {
  ScrollController scrollController = ScrollController();
  TopHeadlineService topHeadlineService;

  String selectedCategory = "all";

  @override
  void initState() {
    topHeadlineService = TopHeadlineService(context: context);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        topHeadlineService.loadMore(category: selectedCategory == 'all' || selectedCategory == null ? null : selectedCategory);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build $selectedCategory");
    return AppDrawer(
      menuItems: CATEGORIES.map((e) {
        return Builder(
          builder: (BuildContext appBarContext) {
            return ListTile(
              selectedTileColor: Colors.blue,
              selected: e.toLowerCase() == selectedCategory,
              onTap: () async {
                AppDrawer.of(appBarContext).toggle();
                if (e.toLowerCase() != selectedCategory) {
                  setState(() {
                    selectedCategory = e.toLowerCase();
                  });
                  await topHeadlineService.refresh(category: selectedCategory == 'all' || selectedCategory == null ? null : selectedCategory);
                }
              },
              title: Text(e, style: TextStyle(color: Theme.of(context).textTheme.headline6.color)),
            );
          },
        );
      }).toList(),
      child: Material(
        elevation: 20,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Builder(
                        builder: (BuildContext appBarContext) {
                          return IconButton(
                            onPressed: () {
                              AppDrawer.of(appBarContext).toggle();
                            },
                            icon: Icon(Icons.menu),
                          );
                        },
                      ),
                      Expanded(child: Text("${selectedCategory[0].toUpperCase()}${selectedCategory.substring(1)}", style: TextStyle(fontSize: 18))),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text("News Bulletin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: NewsBuilder(
                    onRefresh: () {
                      return topHeadlineService.refresh(category: selectedCategory == 'all' || selectedCategory == null ? null : selectedCategory);
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
      ),
    );
  }
}

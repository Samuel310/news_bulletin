import 'package:flutter/material.dart';
import 'package:news_bulletin/screens/search_articles/search_article_screen.dart';
import 'package:news_bulletin/screens/source/source_screen.dart';
import 'package:news_bulletin/screens/top_headlines/top_headlines_screen.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getContentView(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.notes_rounded),
            label: 'Headlines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Source',
          )
        ],
      ),
    );
  }

  Widget getContentView() {
    if (_currentIndex == 0) {
      return TopHeadlinesScreen();
    } else if (_currentIndex == 1) {
      return SearchScreen();
    } else {
      return SourceScreen();
    }
  }
}

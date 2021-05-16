import 'package:flutter/material.dart';
import 'package:news_bulletin/common/functions/dark_theme.dart';
import 'package:news_bulletin/common/functions/light_theme.dart';
import 'package:news_bulletin/common/functions/theme_provider.dart';
import 'package:news_bulletin/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeChangeProvider = new ThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getDartTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            theme: themeChangeProvider.darkTheme ? myDarkTheme : myLightTheme, // CustomStyle.themeData(themeChangeProvider.darkTheme, context),
            debugShowCheckedModeBanner: false,
            initialRoute: HomeScreen.routeName,
            routes: {
              HomeScreen.routeName: (context) => HomeScreen(),
            },
          );
        },
      ),
    );
  }
}

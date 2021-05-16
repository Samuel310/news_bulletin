import 'package:flutter/material.dart';
import 'package:news_bulletin/common/functions/theme_provider.dart';
import 'package:news_bulletin/common/widgets/loader.dart';
import 'package:news_bulletin/models/source.dart';
import 'package:news_bulletin/services/api.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceScreen extends StatefulWidget {
  @override
  _SourceScreenState createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {
  bool isScreenLoading = true;
  Sources sources;
  final GlobalKey _menuKey = new GlobalKey();

  @override
  void initState() {
    loadAllSources();
    super.initState();
  }

  void loadAllSources() async {
    sources = await apiRepo.getAllSources();
    setState(() {
      isScreenLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeChange = Provider.of<ThemeProvider>(context);
    final button = new PopupMenuButton(
      key: _menuKey,
      itemBuilder: (_) => <PopupMenuItem<bool>>[
        PopupMenuItem<bool>(child: themeChange.darkTheme ? Text('Light theme') : Text('Dark theme'), value: themeChange.darkTheme ? false : true),
      ],
      onSelected: (value) {
        print("changing theme");
        themeChange.darkTheme = value;
      },
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Our Source", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
                button,
              ],
            ),
            isScreenLoading
                ? Expanded(child: Container(child: Center(child: initialLoader)))
                : Expanded(
                    child: ListView.separated(
                      itemCount: sources.sources.length,
                      separatorBuilder: (BuildContext context, int index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          title: Text(sources.sources[index].name),
                          subtitle: Text(sources.sources[index].description),
                          onTap: () async {
                            if (await canLaunch(sources.sources[index].url)) {
                              await launch(sources.sources[index].url);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unable to open.")));
                            }
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

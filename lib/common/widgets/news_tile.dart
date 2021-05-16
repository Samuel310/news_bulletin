import 'package:flutter/material.dart';
import 'package:news_bulletin/common/functions/get_formatted_date.dart';
import 'package:news_bulletin/config.dart';
import 'package:news_bulletin/models/top-headlines.dart';
import 'package:package_info/package_info.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsTile extends StatelessWidget {
  final News newsModel;
  NewsTile({@required this.newsModel});
  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () async {
            if (await canLaunch(newsModel.url)) {
              await launch(newsModel.url);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unable to open.")));
            }
          },
          child: Column(
            children: [
              Visibility(
                visible: newsModel.urlToImage != null,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    image: newsModel.urlToImage != null
                        ? DecorationImage(
                            image: NetworkImage(newsModel.urlToImage),
                            fit: BoxFit.fill,
                          )
                        : null,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          color: Colors.black.withOpacity(0.6),
                          child: IconButton(
                            icon: Icon(
                              Icons.share_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              PackageInfo packageInfo = await PackageInfo.fromPlatform();
                              SocialShare.shareOptions(newsModel.url + "\n\n" + "Download the latest " + packageInfo.appName + " app by clicking the link below," + "\n" + APP_PLAYSTORE_URL);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Container(
                  child: Text(
                    newsModel.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                child: Container(
                  child: Row(
                    children: [
                      Text(
                        getFormattedDate(newsModel.publishedAt),
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 2),
                child: Visibility(
                  visible: newsModel.description != null,
                  child: Container(
                    child: Text(newsModel.description != null ? newsModel.description : ""),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

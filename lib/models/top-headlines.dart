import 'dart:convert';

TopHeadlines topHeadlinesFromJson(Map<String, dynamic> str) =>
    TopHeadlines.fromJson(str);

String topHeadlinesToJson(TopHeadlines data) => json.encode(data.toJson());

class TopHeadlines {
  TopHeadlines({
    this.status,
    this.totalResults,
    this.news,
  });

  String status;
  int totalResults;
  List<News> news;

  factory TopHeadlines.fromJson(Map<String, dynamic> json) => TopHeadlines(
        status: json["status"],
        totalResults: json["totalResults"],
        news: List<News>.from(json["articles"].map((x) => News.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(news.map((x) => x.toJson())),
      };
}

class News {
  News({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

  factory News.fromJson(Map<String, dynamic> json) => News(
        source: Source.fromJson(json["source"]),
        author: json["author"] == null ? null : json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author == null ? null : author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
      };
}

class Source {
  Source({
    this.id,
    this.name,
  });

  dynamic id;
  String name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

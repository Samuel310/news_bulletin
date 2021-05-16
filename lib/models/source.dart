import 'dart:convert';

Sources sourcesFromJson(Map<String, dynamic> str) => Sources.fromJson(str);

String sourcesToJson(Sources data) => json.encode(data.toJson());

class Sources {
  Sources({
    this.status,
    this.sources,
  });

  String status;
  List<Source> sources;

  factory Sources.fromJson(Map<String, dynamic> json) => Sources(
        status: json["status"],
        sources: List<Source>.from(json["sources"].map((x) => Source.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "sources": List<dynamic>.from(sources.map((x) => x.toJson())),
      };
}

class Source {
  Source({
    this.id,
    this.name,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
  });

  String id;
  String name;
  String description;
  String url;
  Category category;
  Language language;
  String country;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        url: json["url"],
        category: categoryValues.map[json["category"]],
        language: languageValues.map[json["language"]],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "url": url,
        "category": categoryValues.reverse[category],
        "language": languageValues.reverse[language],
        "country": country,
      };
}

enum Category { GENERAL, TECHNOLOGY, BUSINESS, SPORTS, ENTERTAINMENT, HEALTH, SCIENCE }

final categoryValues = EnumValues({"business": Category.BUSINESS, "entertainment": Category.ENTERTAINMENT, "general": Category.GENERAL, "health": Category.HEALTH, "science": Category.SCIENCE, "sports": Category.SPORTS, "technology": Category.TECHNOLOGY});

enum Language { EN }

final languageValues = EnumValues({"en": Language.EN});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

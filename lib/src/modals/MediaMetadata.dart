part of flutter_video_cast;

abstract class MediaMetaData {
  // int type;
  // int metaDataType;
  Map<String, dynamic> toMap();
  String get contentTitle;
  List<String>? get images;
}

class MovieMediaMetaData extends MediaMetaData {
  static const int metadataType = 1;
  String? title;
  String? subtitle;
  String? studio;
  List<String>? images;
  MovieMediaMetaData({this.title, this.subtitle, this.images, this.studio});

  @override
  Map<String, dynamic> toMap() {
    return {
      "metadataType": metadataType,
      'title': title,
      'subtitle': subtitle,
      'studio': studio,
      'images': images?.map((e) => <String, dynamic>{"url": e}).toList(),
    };
  }

  String get contentTitle {
    return this.title ?? "";
  }

  factory MovieMediaMetaData.fromMap(Map<String, dynamic> map) {
    List<String> images = [];
    if(map["images"] != null){
    images = ((map["images"] ?? []) as List).map((e) => e['url'].toString()).toList();
    }
    return MovieMediaMetaData(
      title: map['title'],
      subtitle: map['subtitle'],
      studio: map['studio'],
      images: images,
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieMediaMetaData.fromJson(String source) =>
      MovieMediaMetaData.fromMap(json.decode(source));
}

class TvShowMediaMetaData extends MediaMetaData {
  static const int metadataType = 2;
  final String? seriesTitle;
  final String? subtitle;
  final int? season;
  final int? episode;
  final List<String>? images;
  TvShowMediaMetaData({
    this.seriesTitle,
    this.subtitle,
    this.season,
    this.episode,
    this.images,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "metadataType": 2,
      'seriesTitle': seriesTitle,
      'subtitle': subtitle,
      'season': season,
      'episode': episode,
      'images': images!.map((e) => <String, dynamic>{"url": e}).toList(),
    };
  }

  String get contentTitle {
    return this.seriesTitle ?? "";
  }

  factory TvShowMediaMetaData.fromMap(Map<String, dynamic> map) {
    List<String> images = [];
    images = (map["images"] as List).map((e) => e['url'].toString()).toList();
    return TvShowMediaMetaData(
      seriesTitle: map['seriesTitle'],
      subtitle: map['subtitle'],
      season: map['season']?.toInt(),
      episode: map['episode']?.toInt(),
      images: images,
    );
  }

  String toJson() => json.encode(toMap());

  factory TvShowMediaMetaData.fromJson(String source) =>
      TvShowMediaMetaData.fromMap(json.decode(source));
}

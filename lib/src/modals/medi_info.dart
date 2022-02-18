part of flutter_video_cast;
// import 'dart:convert';

// import 'package:flutter_video_cast/src/modals/MediaMetadata.dart';

class MediaInfo {
  String contentId;
  String? contentType;
  String? streamType;
  double? duration;
  MediaMetaData? metaData;
  Map<String, dynamic>? customData;
  MediaInfo(
      {required this.contentId,
      this.contentType,
      this.streamType,
      this.duration,
      this.customData,
      this.metaData});

  Map<String, dynamic> toMap() {
    return {
      'contentId': contentId,
      if (contentType != null) 'contentType': contentType,
      if (streamType != null) 'streamType': streamType,
      if (metaData != null) 'metadata': metaData!.toMap(),
    };
  }

  factory MediaInfo.fromJson(Map<String, dynamic> json) {
     MediaMetaData? mediaMetaData;
    if (json['metadata'] != null) {
      switch (json['metadata']['metadataType'] as int) {
        case 1:
          mediaMetaData = MovieMediaMetaData.fromMap(json['metadata']);
          break;
        case 2:
          mediaMetaData = TvShowMediaMetaData.fromMap(json['metadata']);
          break;
      }
    }
    return MediaInfo(
        contentId: json['contentId'],
        streamType: json['streamType'],
        duration: json['duration'].toDouble(),
        metaData: mediaMetaData);
  }

  // factory MediaInfo.fromMap(Map<String, dynamic> map) {
  //   return MediaInfo(
  //     map['contentId'] ?? '',
  //     map['contentType'],
  //     map['streamType'],
  //     map['metaData'] != null ? MediaMetaData.fromMap(map['metaData']) : null,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory MediaInfo.fromJson(String source) => MediaInfo.fromMap(json.decode(source));
}

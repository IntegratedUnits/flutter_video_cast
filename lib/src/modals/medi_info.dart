part of flutter_video_cast;
// import 'dart:convert';

// import 'package:flutter_video_cast/src/modals/MediaMetadata.dart';

class MediaInfo {
  String contentId;
  String? contentType;
  String? streamType;
  MediaMetaData? metaData;
  MediaInfo(
      {required this.contentId,
      this.contentType,
      this.streamType,
      this.metaData});

  Map<String, dynamic> toMap() {
    return {
      'contentId': contentId,
      if (contentType != null) 'contentType': contentType,
      if (streamType != null) 'streamType': streamType,
      if (metaData != null) 'metadata': metaData!.toMap(),
    };
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

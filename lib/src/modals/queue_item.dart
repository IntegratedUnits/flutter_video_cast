part of flutter_video_cast;

class MediaQueueItem {
  final bool? autoPlay;
  final String? itemId;
  final MediaInfo media;
  final int? playbackDuration;
  final double? preLoadTime;
  MediaQueueItem({
    this.autoPlay,
    this.itemId,
    this.preLoadTime = 10.0,
    required this.media,
    this.playbackDuration,
  });

  Map<String, dynamic> toMap() {
    return {
      if (autoPlay != null) 'autoPlay': autoPlay,
      if (itemId != null) 'itemId': itemId,
      'media': media.toMap(),
      "preloadTime": preLoadTime,
      if (playbackDuration != null) 'playbackDuration': playbackDuration,
    };
  }

  // factory MediaQueueItem.fromMap(Map<String, dynamic> map) {
  //   return MediaQueueItem(
  //     autoPlay: map['autoPlay'],
  //     itemId: map['itemId'],
  //     media: MediaInfo.fromMap(map['media']),
  //     playbackDuration: map['playbackDuration']?.toInt(),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory MediaQueueItem.fromJson(String source) => MediaQueueItem.fromMap(json.decode(source));
}

part of flutter_video_cast;

class MediaLoadRequestData {
  MediaLoadRequestData({this.media, this.queueData});
  MediaInfo? media;
  QueueData? queueData;
  Map<String, dynamic> toJsonMap() {
    return {
      if (media != null) "media": media!.toMap(),
      if (queueData != null) "queueData": queueData!.toMap()
    };
  }
}

// class SingleMediaLoadRequestData extends MediaLoadRequestData {
//   MediaInfo? media;
//   SingleMediaLoadRequestData({required this.media});

//   @override
//   Map<String, dynamic> toJsonMap() {
//     return {
//       'type': 'single',
//       "media": media?.toMap(),
//     };
//   }
// }

// class MultipleMediaLoadRequestData extends MediaLoadRequestData {
//   QueueData queueData;

//   MultipleMediaLoadRequestData({
//     required this.queueData,
//   });

//   @override
//   Map<String, dynamic> toJsonMap() {
//     return {
//       'type': 'LOAD',
//       "queueData": queueData.toMap(),
//     };
//   }
// }

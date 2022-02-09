
part of flutter_video_cast;

class QueueData {
  final int queueId;
  final int? startIndex;
  final QueueType? queueType;
  final String? name;
  List<MediaQueueItem> items;
  QueueData(
      {required this.queueId,
      required this.items,
      this.startIndex,
      this.queueType,
      this.name});

  // QueueData()

  Map<String, dynamic> toMap() {
    return {
      'queueId': queueId,
      if (startIndex != null) 'startIndex': startIndex,
      if (queueType != null) 'queueType': queueType?.value(),
      if (name != null) 'name': name,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  // factory QueueData.fromMap(Map<String, dynamic> map) {
  //   return QueueData(
  //     map['queueId']?.toInt() ?? 0,
  //     map['startIndex']?.toInt(),
  //     map['queueType'] != null ? QueueType.fromMap(map['queueType']) : null,
  //     map['name'],
  //     List<MediaQueueItem>.from(map['items']?.map((x) => MediaQueueItem.fromMap(x))),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory QueueData.fromJson(String source) => QueueData.fromMap(json.decode(source));
}

enum QueueType {
  TV_SERIES,
  MOVE,
}

extension QueueTypeExtension on QueueType {
  int value() {
    switch (this) {
      case QueueType.TV_SERIES:
        return 6;
      case QueueType.MOVE:
        return 9;
    }
  }
}

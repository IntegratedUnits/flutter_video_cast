part of flutter_video_cast;

enum PlayerStatus {
  PAUSED,
  PLAYING,
  IDLE,
  BUFFERING,
  NON,
}
PlayerStatus getPlayeStatus(String s) {
  switch (s) {
    case "PLAYING":
      return PlayerStatus.PLAYING;
    case "PAUSED":
      return PlayerStatus.PAUSED;
    case "BUFFERING":
      return PlayerStatus.BUFFERING;
    case "IDLE":
      return PlayerStatus.IDLE;
  }
  return PlayerStatus.NON;
}

enum IdelReason {
  CANCELLED,
  FINISHED,
  NON,
}
IdelReason getIdelReasonFromString(String s) {
  switch (s) {
    case "CANCELLED":
      return IdelReason.CANCELLED;
    case "FINISHED":
      return IdelReason.FINISHED;
  }
  return IdelReason.NON;
}

class MediaStatus {
  MediaInfo? mediaInfo;
  QueueData? queueData;
  PlayerStatus? playerState;
  Duration? possition;
  IdelReason? idelReason;
  MediaStatus(
      {this.possition,
      this.mediaInfo,
      this.playerState,
      this.queueData,
      this.idelReason});
  factory MediaStatus.fromJson(Map<String, dynamic> json) {
    return MediaStatus(
      mediaInfo:
          (json["media"] == null) ? null : MediaInfo.fromJson(json['media']),
      playerState: getPlayeStatus(json['playerState']),
      possition: Duration(
        seconds: json['currentTime'].toInt(),
      ),
      queueData:
          json['queueData'] == null ? null : QueueData(queueId: 0, items: []),
      idelReason: json["idleReason"] == null
          ? null
          : getIdelReasonFromString(json['idleReason']),
    );
  }
}

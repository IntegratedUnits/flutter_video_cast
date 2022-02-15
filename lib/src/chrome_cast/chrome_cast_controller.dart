part of flutter_video_cast;

final ChromeCastPlatform _chromeCastPlatform =
    ChromeCastPlatform.instance as ChromeCastPlatform;

/// Controller for a single ChromeCastButton instance running on the host platform.
class ChromeCastController {
  ChromeCastController._({required this.id});

  /// The id for this controller
  final int id;

  /// Initialize control of a [ChromeCastButton] with [id].
  static Future<ChromeCastController> init(int id) async {
    await _chromeCastPlatform.init(id);
    return ChromeCastController._(id: id);
  }

  /// Add listener for receive callbacks.
  Future<void> addSessionListener() {
    return _chromeCastPlatform.addSessionListener(id: id);
  }

  /// Remove listener for receive callbacks.
  Future<void> removeSessionListener() {
    return _chromeCastPlatform.removeSessionListener(id: id);
  }

  /// Load a new media by providing an [url].
  Future<void> loadMedia(String url, Map<String, dynamic> meta) {
    return _chromeCastPlatform.loadMedia(url, meta, id: id);
  }

  /// load video with reuqest data object
  Future<void> load(MediaLoadRequestData requestData) {
    return _chromeCastPlatform.load(requestData, id: id);
  }

  Future<void> loadMediaTvShow(Map<String, dynamic> meta) {
    return _chromeCastPlatform.loadMediaTvShow(meta, id: id);
  }

  /// Load subtitles
  Future<void> activeTracks() {
    return _chromeCastPlatform.activeTracks(id: id);
  }

  /// Plays the video playback.
  Future<void> play() {
    return _chromeCastPlatform.play(id: id);
  }

  /// Pauses the video playback.
  Future<void> pause() {
    return _chromeCastPlatform.pause(id: id);
  }

  /// If [relative] is set to false sets the video position to an [interval] from the start.
  ///
  /// If [relative] is set to true sets the video position to an [interval] from the current position.
  Future<void> seek({bool relative = false, double interval = 10.0}) {
    return _chromeCastPlatform.seek(relative, interval, id: id);
  }

  /// Set volume 0-1
  Future<void> setVolume({double volume = 0}) {
    return _chromeCastPlatform.setVolume(volume, id: id);
  }

  /// Get current volume
  Future<double> getVolume() {
    return _chromeCastPlatform.getVolume(id: id);
  }

  /// Stop the current video.
  Future<void> stop() {
    return _chromeCastPlatform.stop(id: id);
  }

  /// Returns `true` when a cast session is connected, `false` otherwise.
  Future<bool?> isConnected() {
    return _chromeCastPlatform.isConnected(id: id);
  }

  /// End current session
  Future<void> endSession() {
    return _chromeCastPlatform.endSession(id: id);
  }

  /// Returns `true` when a cast session is playing, `false` otherwise.
  Future<bool?> isPlaying() {
    return _chromeCastPlatform.isPlaying(id: id);
  }

  /// Returns current position.
  Future<Duration> position() {
    // return Future<Duration>.value(Duration(seconds: 10));
    return _chromeCastPlatform.position(id: id);
  }

  /// Returns video duration.
  Future<Duration> duration() {
    return _chromeCastPlatform.duration(id: id);
  }

  // play next video in queue
  Future<void> queueNext() {
    return _chromeCastPlatform.queueNext(id: id);
  }

  // play previous video in queue
  Future<void> queuePrevious() {
    return _chromeCastPlatform.queuePrevious(id: id);
  }

  Future<MediaStatus?> getMediaStatus() async {
    final s = await _chromeCastPlatform.getMediaInfo(id: id);
    // log(s);
    if (s == "" || s == null) {
      return null;
    }
    final posittion = await position();
    return MediaStatus.fromJson(jsonDecode(s))..possition = posittion;
  }
}

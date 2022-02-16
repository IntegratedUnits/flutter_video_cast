import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_cast/flutter_video_cast.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_event.dart';
import 'package:flutter_video_cast/src/chrome_cast/method_channel_chrome_cast.dart';

/// The interface that platform-specific implementations of `flutter_video_cast` must extend.
abstract class ChromeCastPlatform {
  static ChromeCastPlatform _instance = MethodChannelChromeCast();

  /// The default instance of [ChromeCastPlatform] to use.
  ///
  /// Defaults to [MethodChannelChromeCast].
  static ChromeCastPlatform get instance => _instance;

  /// Initializes the platform interface with [id].
  ///
  /// This method is called when the plugin is first initialized.
  Future<void> init(int id) {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// Add listener for receive callbacks.
  Future<void> addSessionListener({required int id}) {
    throw UnimplementedError('addSessionListener() has not been implemented.');
  }

  /// Remove listener for receive callbacks.
  Future<void> removeSessionListener({required int id}) {
    throw UnimplementedError(
        'removeSessionListener() has not been implemented.');
  }

  /// A session is started.
  Stream<SessionStartedEvent> onSessionStarted({required int id}) {
    throw UnimplementedError('onSessionStarted() has not been implemented.');
  }

  /// A session is ended.
  Stream<SessionEndedEvent> onSessionEnded({required int id}) {
    throw UnimplementedError('onSessionEnded() has not been implemented.');
  }

  /// A request has completed.
  Stream<RequestDidCompleteEvent> onRequestCompleted({required int id}) {
    throw UnimplementedError('onRequestCompleted() has not been implemented.');
  }

  /// A request has failed.
  Stream<RequestDidFailEvent> onRequestFailed({required int id}) {
    throw UnimplementedError('onSessionEnded() has not been implemented.');
  }

  /// Load a new media by providing an [url].
  Future<void> loadMedia(
    String url,
    Map<String, dynamic> meta, {
    required int id,
  }) {
    throw UnimplementedError('loadMedia() has not been implemented.');
  }

  Future<void> loadMediaTvShow(
    Map<String, dynamic> meta, {
    required int id,
  }) {
    throw UnimplementedError('loadMedia() has not been implemented.');
  }

  //// load with request data object
  Future<void> load(MediaLoadRequestData requestData, {required int id}) {
    throw UnimplementedError(
        'load(MediaLoadRequestData) has not been implemented.');
  }

  /// Plays the video playback.
  Future<void> play({required int id}) {
    throw UnimplementedError('play() has not been implemented.');
  }

  /// activeTracks subtitles on the video playback.
  Future<void> activeTracks({required int id}) {
    throw UnimplementedError('activeTracks() has not been implemented.');
  }

  /// Pauses the video playback.
  Future<void> pause({required int id}) {
    throw UnimplementedError('pause() has not been implemented.');
  }

  /// If [relative] is set to false sets the video position to an [interval] from the start.
  ///
  /// If [relative] is set to true sets the video position to an [interval] from the current position.
  Future<void> seek(bool relative, double interval, {required int id}) {
    throw UnimplementedError('pause() has not been implemented.');
  }

  /// Set volume
  Future<void> setVolume(double volume, {required int id}) {
    throw UnimplementedError('setVolume() has not been implemented.');
  }

  /// Get volume
  Future<double> getVolume({required int id}) {
    throw UnimplementedError('getVolume() has not been implemented.');
  }

  /// Stop the current video.
  Future<void> stop({required int id}) {
    throw UnimplementedError('stop() has not been implemented.');
  }

  /// Returns `true` when a cast session is connected, `false` otherwise.
  Future<bool?> isConnected({required int id}) {
    throw UnimplementedError('seek() has not been implemented.');
  }

  /// End current session
  Future<void> endSession({required int id}) {
    throw UnimplementedError('seek() has not been implemented.');
  }

  /// Returns `true` when a cast session is playing, `false` otherwise.
  Future<bool?> isPlaying({required int id}) {
    throw UnimplementedError('isPlaying() has not been implemented.');
  }

  Future<Duration> position({required int id}) {
    throw UnimplementedError('position() has not been implemented.');
  }

  Future<Duration> duration({required int id}) {
    throw UnimplementedError('duration() has not been implemented.');
  }

  /// get Media status
  Future<String> getMediaInfo({required int id}) {
    throw UnimplementedError('getMediaInfo() has not been implemented.');
  }
  Future<Map> getMediaInfoIOS({required int id}){
    throw UnimplementedError('getMediaInfoIOS() has not been implemented.');
  } 

  /// play next video in queue
  Future<void> queueNext({required int id}) {
    throw UnimplementedError('queueNext() has not been implemented.');
  }

  Future<void> queuePrevious({required int id}) {
    throw UnimplementedError('queuePrevious() has not been implemented.');
  }

  /// Returns a widget displaying the button.
  Widget buildView(Map<String, dynamic> arguments,
      PlatformViewCreatedCallback onPlatformViewCreated) {
    throw UnimplementedError('buildView() has not been implemented.');
  }
}

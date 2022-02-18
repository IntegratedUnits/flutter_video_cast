import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_video_cast/flutter_video_cast.dart';

import 'package:flutter_video_cast_example/timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CastSample());
  }
}

class CastSample extends StatefulWidget {
  static const _iconSize = 50.0;

  @override
  _CastSampleState createState() => _CastSampleState();
}

class _CastSampleState extends State<CastSample> {
  late ChromeCastController _controller;
  AppState _state = AppState.idle;
  bool? _playing = false;

  Duration position = Duration();
  Duration duration = Duration();

  double volume = 0;

  Timer _timer = Timer();
  StreamSubscription<int>? _tickerSubscription;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plugin example app'),
        actions: <Widget>[
          AirPlayButton(
            size: CastSample._iconSize,
            color: Colors.white,
            activeColor: Colors.amber,
            onRoutesOpening: () => print('opening'),
            onRoutesClosed: () => print('closed'),
          ),
          ChromeCastButton(
            size: CastSample._iconSize,
            color: Colors.white,
            onButtonCreated: _onButtonCreated,
            onSessionStarted: _onSessionStarted,
            onSessionEnded: _onSessionEnded,
            onRequestCompleted: _onRequestCompleted,
            onRequestFailed: _onRequestFailed,
          ),
        ],
      ),
      body: Center(child: _handleState()),
    );
  }

  Widget _handleState() {
    switch (_state) {
      case AppState.idle:
        return Text('ChromeCast not connected');
      case AppState.connected:
        return Text('No media loaded');
      case AppState.mediaLoaded:
        return _mediaControls();
      case AppState.error:
        return Text('An error has occurred');
      default:
        return Container();
    }
  }

  Widget _mediaControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _RoundIconButton(
              icon: Icons.skip_previous,
              onPressed: () => _controller.queuePrevious(),
            ),
            _RoundIconButton(
              icon: Icons.replay_10,
              onPressed: () =>
                  _controller.seek(relative: true, interval: -10.0),
            ),
            _RoundIconButton(
                icon: _playing! ? Icons.pause : Icons.play_arrow,
                onPressed: _playPause),
            _RoundIconButton(
              icon: Icons.forward_10,
              onPressed: () => _controller.seek(relative: true, interval: 10.0),
            ),
            _RoundIconButton(
              icon: Icons.skip_next,
              onPressed: () => _controller.queueNext(),
            ),
          ],
        ),
        Slider(
          value: .5,
          onChanged: (double value) {
            _changeSliderValue(value);
          },
          
        ),
        Text(_time()),
        /*
        //End session
        _RoundIconButton(
          icon: Icons.stop,
          onPressed: () => _controller.endSession(),
        ),
         */
      ],
    );
  }

  String _time() {
    if (duration.inHours > 0) {
      return "${formatHour(position)} / ${formatHour(duration)}";
    } else {
      return "${format(position)} / ${format(duration)}";
    }
  }

  format(Duration d) => d.toString().substring(2, 7);
  formatHour(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  double _sliderValue() {
    return position.inSeconds /
        (duration.inSeconds == 0 ? 5 : duration.inSeconds);
  }

  _changeSliderValue(double value) {
    position = Duration(
      seconds:
          ((duration.inSeconds == 0 ? 5 : duration.inSeconds) * value).toInt(),
    );
    _changePosition(position);
    setState(() {});
  }

  _changePosition(Duration position) async {
    if ((await _controller.isConnected()) ?? false) {
      await _controller.seek(interval: position.inSeconds.toDouble());
      position = await _controller.position();
      setState(() {});
    }
  }

  Future<void> _playPause() async {
    final bool playing = (await _controller.isPlaying()) ?? false;
    if (playing) {
      await _controller.pause();
      _tickerSubscription?.cancel();
    } else {
      await _controller.play();
      _tickerSubscription?.cancel();
      _tickerSubscription = _timer.tick(ticks: 0).listen((time) async {
        position = await _controller.position();
        final response = await _controller.getMediaStatus();
        log((response?.mediaInfo?.toMap()).toString() + "////./// mediaInfo");
        setState(() {});
      });
    }
    setState(() => _playing = !playing);
  }

  Future<void> _onButtonCreated(ChromeCastController controller) async {
    _controller = controller;
    await _controller.addSessionListener();
    final v = await _controller.duration();
    print("a");
    log(v.toString());
  }

  Future<void> _onSessionStarted() async {
    setState(() => _state = AppState.connected);
    String urlVideo =
        "https://multiplatform-f.akamaihd.net/i/multi/will/bunny/big_buck_bunny_,640x360_400,640x360_700,640x360_1000,950x540_1500,.f4v.csmil/master.m3u8";

    // await _controller.loadMediaTvShow({
    //   "url": urlVideo.split("?")[0],
    //   "seriesTitle": "Prova",
    //   "season": 1,
    //   "episode": 10,
    //   "currentTime": 40000,
    //   "image":
    //       "https://upload.wikimedia.org/wikipedia/commons/2/22/Big.Buck.Bunny.-.Bunny.Portrait.png"
    // });
    print("url -----"+urlVideo);
    await _controller.load(
      MediaLoadRequestData(
        // media: MediaInfo(
        //   contentId: urlVideo,
        //   metaData: MovieMediaMetaData(title: "Title"),
        // ),
        queueData: QueueData(items: [
          MediaQueueItem(
            media: MediaInfo(
              contentId: urlVideo.split("?")[0],
              metaData: TvShowMediaMetaData(
                  seriesTitle: "Title 1",
                  episode: 1,
                  images: [
                    'https://upload.wikimedia.org/wikipedia/commons/2/22/Big.Buck.Bunny.-.Bunny.Portrait.png'
                  ]),
            ),
          ),
          MediaQueueItem(
              media: MediaInfo(
            contentId:
                "https://vz-6de847a3-2cb.b-cdn.net/b82019af-1a6d-4956-909e-acc11ff79f64/playlist.m3u8?height=1080&userid=&video_version=2.8&platform=ruman&default_source=2.8"
                    .split("?")[0],
            metaData: TvShowMediaMetaData(
                seriesTitle: "Title 1",
                episode: 2,
                images: [
                  'https://upload.wikimedia.org/wikipedia/commons/2/22/Big.Buck.Bunny.-.Bunny.Portrait.png'
                ]),
          ))
        ],
         queueId: 0, startIndex: 1),
      ),
    );
  }

  Future<void> _onSessionEnded() async {
    _tickerSubscription?.cancel();
    position = Duration();
    duration = Duration();
    setState(() => _state = AppState.idle);
  }

  Future<void> _onRequestCompleted() async {
    final playing = await _controller.isPlaying();
    setState(() {
      _state = AppState.mediaLoaded;
      _playing = playing;
    });
    duration = await _controller.duration();
    setState(() {});
  }

  Future<void> _onRequestFailed(String? error) async {
    _tickerSubscription?.cancel();
    setState(() => _state = AppState.error);
    print(error);
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  _RoundIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Icon(icon, color: Colors.white),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          shape: MaterialStateProperty.all<OutlinedBorder>(CircleBorder()),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.all(16.0),
          ),
        ),
        onPressed: onPressed);
  }
}

enum AppState { idle, connected, mediaLoaded, error }

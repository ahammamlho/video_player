import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:multiads/multiads.dart';
import 'package:player/app_theme.dart';
import 'package:player/constants.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PageVideo extends StatefulWidget {
  final String url;
  const PageVideo({Key? key, required this.url}) : super(key: key);

  @override
  _PageVideoState createState() => _PageVideoState(url);
}

class _PageVideoState extends State<PageVideo> {
  final String url;
  _PageVideoState(this.url);

  late String vraiUrl;
  bool isReady = false;
  late BetterPlayerController _betterPlayerController;

  Future<String> videoURL(String url) async {
    var yt = YoutubeExplode();
    var streamInfo = await yt.videos.streamsClient.getManifest(url);
    var d = streamInfo.muxed.where((e) => e.container == StreamContainer.mp4);
    return d.first.url.toString();
  }

  getUrl() async {
    try {
      if (url.contains("youtube")) {
        vraiUrl = await videoURL(url);
      } else {
        vraiUrl = url;
      }
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        vraiUrl,
      );
      _betterPlayerController = BetterPlayerController(
          const BetterPlayerConfiguration(),
          betterPlayerDataSource: betterPlayerDataSource);
      setState(() {
        isReady = true;
      });
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    getUrl();
  }

  // @override
  // void dispose() {
  //   _betterPlayerController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: const Text(" Player "),
        ),
        body: isReady
            ? AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(
                  controller: _betterPlayerController,
                ),
              )
            : Center(
                child: SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  color: AppTheme.primary,
                  strokeWidth: 6,
                ),
              )));
  }
}

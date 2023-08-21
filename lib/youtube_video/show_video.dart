import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ShowVideoFromYoutube extends StatefulWidget {
  const ShowVideoFromYoutube({Key? key}) : super(key: key);

  @override
  State<ShowVideoFromYoutube> createState() => _ShowVideoFromYoutubeState();
}

class _ShowVideoFromYoutubeState extends State<ShowVideoFromYoutube> {
  final videoURL = "https://youtu.be/3x92z0oHbtY";
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoID= YoutubePlayer.convertUrlToId(videoURL);
    _controller =YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay:  false,
      ),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            YoutubePlayer(
              controller: _controller,
              // showVideoProgressIndicator: true,
              onReady: ()=>debugPrint("Ready"),
              bottomActions: [
                CurrentPosition(),
                ProgressBar(
                  isExpanded: true,
                  colors: const ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.green,
                  ),
                ),
                const PlaybackSpeedButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

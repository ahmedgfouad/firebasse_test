import 'dart:io';

import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:video_player/video_player.dart';
import 'resources/save_video.dart';

class UploadVideoToFirebase extends StatefulWidget {

  const UploadVideoToFirebase({super.key});

  @override
  State<UploadVideoToFirebase> createState() => _UploadVideoToFirebaseState();
}

class _UploadVideoToFirebaseState extends State<UploadVideoToFirebase> {

  String? _videoURL ;
  VideoPlayerController? _controller ;
  String? _downloadURL ;
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:Center(
        child:_videoURL!= null
            ?_videoPreviewWidget()
            :const Text("No video is selected"),

      ),

      floatingActionButton:  FloatingActionButton(
        onPressed: _pickVideo,
        child: const Icon(Icons.video_collection),
      ),
    );
  }

  void _pickVideo()async{
    _videoURL= await pickVideo();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer(){
    _controller = VideoPlayerController.file(
      File(_videoURL!))
    ..initialize().then((_) {
      setState(() {});
      _controller!.play();
    });
  }

  Widget _videoPreviewWidget(){
    if(_controller != null){
      return Column(
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
            ),
          ),
          ElevatedButton(
              onPressed: _uploadVideo,
              child: const Text("Upload video to firebase"),
          ),
        ],
      );
    }else{
      return const CircularProgressIndicator();
    }
  }

  void _uploadVideo ()async{
    _downloadURL =await StoreData().uploadVideo(_videoURL!);
    await StoreData().saveVideoData(_downloadURL!);
    setState(() {
      _videoURL= null;
    });

  }
}

import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_test/upload_video_with_progress/controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'firebase_api.dart';

class UploadVideoWithProgress extends StatefulWidget {
  const UploadVideoWithProgress({Key? key}) : super(key: key);

  @override
  State<UploadVideoWithProgress> createState() =>
      _UploadVideoWithProgressState();
}

class _UploadVideoWithProgressState extends State<UploadVideoWithProgress> {
  UploadTask? task;
  File? file;
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'no file Selected';
    return Scaffold(
      appBar: AppBar(),
      body: ChangeNotifierProvider(
        create: (context)=>UploadingVideoController(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: selectFile,
                child: const Text("chose file"),
              ),
              const SizedBox(height: 10),
              Text(fileName),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: uploadFile,
                child: const Text("upload file"),
              ),
              const SizedBox(height: 10),
              task != null ? buildUploadStatus(task!) : Container(),

              Consumer<UploadingVideoController>(
               builder : (context ,provider,child)=>CircularPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  radius: 50.0,
                  lineWidth: 10.0,
                  percent: 1.0,
                  backgroundColor: Colors.deepPurple.shade200,
                  progressColor: Colors.deepPurple,
                  center:  Text(provider.progress.toString()),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final picker = ImagePicker();
    XFile? videoFile;
    try{
      videoFile = await picker.pickVideo(source: ImageSource.gallery);
      final thePath= videoFile!.path;
      setState(() {
        file=File(thePath);
      });
    }
    catch(e){
      log("The Error is : $e");
    }

  }

  void uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;
    final snapShot = await task!.whenComplete(() {});
    final urlDownload = await snapShot.ref.getDownloadURL();

    log("download-link $urlDownload");
  }

  Widget buildUploadStatus(UploadTask task) => Consumer<UploadingVideoController>(
    builder: (context,provider,child)=>
    StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            final snap = snapShot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage =(progress *100).toStringAsFixed(2);
            provider.changeProgress(progress);
            print("===================$percentage==============================");
            return Text('$percentage %',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
          } else {
            return Container();
          }
        }),
  );
}

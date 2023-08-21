import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var imagePicker = ImagePicker();

  uploadImage() async {
    var imgPicked = await imagePicker.pickImage(source: ImageSource.camera);
    if (imgPicked !=null) {
      File fileX= File(imgPicked.path);
      var imgName= basename(imgPicked.path);
      var randomImage= Random().nextInt(100);
      print(fileX);
      print(imgPicked.path);
      print(imgName);

      var refStorage = FirebaseStorage.instance.ref("images/$randomImage x");
      await refStorage.putFile(fileX);
      var url = await refStorage.getDownloadURL();
      print(url);

    }
  }

  getNameTheImage()async{
    final storageRef = FirebaseStorage.instance.ref().child("files/uid");
    final listResult = await storageRef.listAll();
    for (var prefix in listResult.prefixes) {
      print("1");
      // The prefixes under storageRef.
      // You can call listAll() recursively on them.
    }
    for (var item in listResult.items) {
      print("2");
      // The items under storageRef.
    }
  }
  // @override
  // void initState() {
  //   getNameTheImage();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cloud Firestore"),
      ),
      body: TextButton(
        onPressed: () async {
           uploadImage();
        },
        child: const Text("upload image"),
      ),
    );
  }
}

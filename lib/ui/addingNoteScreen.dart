import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_test/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddingNoteScreen extends StatefulWidget {
  const AddingNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddingNoteScreen> createState() => _AddingNoteScreenState();
}

Reference? reference;
var imageUrl;
var ref;
File? file;

class _AddingNoteScreenState extends State<AddingNoteScreen> {
  var tittle, note;

  CollectionReference notesRef = FirebaseFirestore.instance.collection('notes');

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  addNotes() async {
    if (file == null) {
      print("file is null please take photo");
      return const Text("please take photo");
    }

    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();
      if (tittle == null && note == null) {
        print('enter the data');
        return Text('Enter the data');
      }
      await uploadingImageToFireStore();
      print("the image url is : $imageUrl");
      notesRef.add({
        'tittle': tittle,
        'notes': note,
        'image_url': imageUrl,
        'user_id': FirebaseAuth.instance.currentUser!.uid,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add notes page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: formState,
          child: Column(
            children: [
              TextFormField(
                validator: (val) {
                  if (val!.length > 100) {
                    print("Tittle can't be bigger than 30 letter ");
                  }
                  if (val.length < 4) {
                    print("Tittle can't be less than 4 letter");
                  }
                  return null;
                },
                onSaved: (val) {
                  tittle = val;
                },
                decoration: const InputDecoration(
                  filled: false,
                  fillColor: Colors.white,
                  hintText: "tittle note",
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (val) {
                  if (val!.length > 100) {
                    print("Note can't be bigger than 300 letter ");
                  }
                  if (val.length < 4) {
                    print("Password can't be less than 4 letter");
                  }
                  return null;
                },
                onSaved: (val) {
                  note = val;
                },
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  filled: false,
                  fillColor: Colors.white,
                  hintText: "note",
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              TextButton(
                  onPressed: () {
                    takeImage();
                  },
                  child: const Text("Add image for note ")),
              TextButton(
                onPressed: () async {
                  addNotes();
                 const Duration(seconds: 10);
                 Navigator.of(context).pop();
                },
                child: const Text("Add note "),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

takeImage() async {
  var imagePicker = ImagePicker();
  var imgPicked = await imagePicker.pickImage(source: ImageSource.camera);
  if (imgPicked != null) {
    file = File(imgPicked.path);
    print("===========$file============");
  }
}

uploadingImageToFireStore() async {
  var randomImage = Random().nextInt(100);
  ref = FirebaseStorage.instance.ref("$randomImage x");
  print(randomImage);
  await ref.putFile(file);
  imageUrl = await ref.getDownloadURL();
  print(file);
  print("===========================");
  print(imageUrl);
  file = null;
}

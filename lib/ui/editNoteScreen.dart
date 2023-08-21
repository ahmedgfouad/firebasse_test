import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditNoteScreen extends StatefulWidget {
  var docId;
  Map? data ;
   EditNoteScreen({Key? key,this.docId,this.data}) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreen();
}

Reference? reference;
var imageUrl;
var ref ;
File? file;

class _EditNoteScreen extends State<EditNoteScreen> {
  var tittle, note;

  CollectionReference notesRef = FirebaseFirestore.instance.collection('notes');

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  editNotes() async {
    var formData = formState.currentState;

    if(file == null) {
      if (formData!.validate()) {
        formData.save();
        if(tittle == null && note == null){
          print('enter the data');
          return Text('Enter the data');
        }
        notesRef.doc(widget.docId).update({
          'tittle': tittle,
          'notes': note,
          'user_id': FirebaseAuth.instance.currentUser!.uid,
        });
      }
    }else{
      if (formData!.validate()) {
        formData.save();
        if(tittle == null && note == null){
          print('enter the data');
          return Text('Enter the data');
        }
        await uploadImageToFirestore();
        print("the image url is : $imageUrl");
        notesRef.doc(widget.docId).update({
          'tittle': tittle,
          'notes': note,
          'image_url': imageUrl,
          'user_id': FirebaseAuth.instance.currentUser!.uid,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit note page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: formState,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.data!['tittle'],
                validator: (val) {
                  if (val!.length > 100) {
                    print("Tittle can't be bigger than 30 letter ");
                  }
                  if (val.length < 2) {
                    print("Tittle can't be less than 2 letter");
                  }
                  return null;
                },
                onSaved: (val) {
                  formState.currentState!.save();
                  print(val);
                  tittle = val;
                  print(tittle);
                },
                decoration: const InputDecoration(
                  filled: false,
                  fillColor: Colors.white,
                  hintText: "tittle note",
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                initialValue: widget.data!['notes'],
                validator: (val) {
                  if (val!.length > 100) {
                    print("Note can't be bigger than 300 letter ");
                  }
                  if (val.length < 2) {
                    print("Note can't be less than 2 letter");
                  }
                  return null;
                },
                onSaved: (val) {
                  formState.currentState!.save();
                  print(val);
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
                    // showTheSheet(context);
                    tackImage();
                  },
                  child: const Text("Edit image for note ")),
              TextButton(
                onPressed: () async {
                  editNotes();
                  Navigator.of(context).pop();
                },
                child: const Text("Save note "),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

tackImage() async {

  var imagePicker =ImagePicker();
  var imgPicked = await imagePicker.pickImage(source: ImageSource.camera);
  if (imgPicked !=null) {
    file= File(imgPicked.path);
  }
}

uploadImageToFirestore() async {
  var randomImage= Random().nextInt(100);
  ref = FirebaseStorage.instance.ref("$randomImage x");
  print(randomImage);
  await ref.putFile(file);
  imageUrl= await ref.getDownloadURL();
  print(file);
  print("===========================");
  print(imageUrl);
  file = null;
}


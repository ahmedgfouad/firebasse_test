import 'dart:developer';

import'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_test/auth/LogIn.dart';
import 'package:firebase_test/video/home_upload_vido_to_firebase.dart';
import 'package:firebase_test/test.dart';
import 'package:firebase_test/ui/editNoteScreen.dart';
import 'package:firebase_test/ui/viewNote.dart';
import 'package:flutter/material.dart';
import 'addingNoteScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference userRef = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
              onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UploadVideoToFirebase()));
          }, icon: const Icon(Icons.add)),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>  LogInScreen(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddingNoteScreen()));
        },
      ),
      body: FutureBuilder(
        future: userRef
            .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemCount: snapShot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map notesData = snapShot.data!.docs[index].data() as Map;
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewNote(
                        noteData: notesData,
                      )));
                    },
                    child: Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction){
                        userRef.doc(snapShot.data!.docs[index].id).delete();
                        FirebaseStorage.instance.refFromURL('${notesData['image_url']}').delete().then((value) {
                          log('===================');
                          log('delete');
                        });
                      },

                      child: ListTile(
                        title: Text("${notesData['tittle']}"),
                        subtitle: Text("${notesData['notes']}"),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditNoteScreen(
                                  docId: snapShot.data!.docs[index].id,
                                  data: notesData,
                                ),
                              ),
                            );
                            log(notesData['tittle']);
                            log(notesData['notes']);
                          },
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        leading: Image.network('${notesData['image_url']}'),
                      ),
                    ),
                  );
                });
          }
          if (snapShot.hasError) {
            return const Text("Eroor");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

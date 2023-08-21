import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/auth/LogIn.dart';
import 'package:firebase_test/upload_video_with_progress/view.dart';
import 'package:firebase_test/video/home_upload_vido_to_firebase.dart';
import 'package:firebase_test/ui/home.dart';
import 'package:firebase_test/youtube_video/show_video.dart';
import 'package:flutter/material.dart';

bool? isLogIn;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    isLogIn = false;
  } else {
    isLogIn = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home : UploadVideoWithProgress(),
       // isLogIn! ? const HomeScreen() :
      // const LogInScreen(),
    );
  }
}

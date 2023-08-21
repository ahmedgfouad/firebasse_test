import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/auth/LogIn.dart';
import 'package:firebase_test/componant/showLoading.dart';
import 'package:firebase_test/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  var myUserName, myEmail, myPassword;

  signUp() async{
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();
      try {
        showLoading(context);
         UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: myEmail,
          password: myPassword,
        );
         return userCredential ;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          Navigator.pop(context);

        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          Navigator.pop(context);
        }
      } catch (e) {
        print(e);
      }
      // print("The user UID = ${userCredential.user!.uid}");

    }
    else{
      print("Not Validate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formState,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (val) {
                      myUserName = val;
                    },
                    validator: (val) {
                      if (val!.length > 100) {
                        print("Username can't be bigger than 100 letter ");
                      }
                      if (val.length < 2) {
                        print("Username can't be less than 2 letter");
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Username",
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onSaved: (val) {
                      myEmail = val;
                    },
                    validator: (val) {
                      if (val!.length > 100) {
                        print("Email can't be bigger than 100 letter ");
                      }
                      if (val.length < 2) {
                        print("Email can't be less than 2 letter");
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "Email",
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onSaved: (val) {
                      myPassword = val;
                    },
                    validator: (val) {
                      if (val!.length > 100) {
                        print("Password can't be bigger than 100 letter ");
                      }
                      if (val.length < 4) {
                        print("Password can't be less than 2 letter");
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.remove_red_eye_outlined),
                      hintText: "Password",
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text("If you have Account "),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LogInScreen()));
                          },
                          child: const Text("Log In")),
                    ],
                  ),
                  TextButton(
                      onPressed: () async{
                   UserCredential response= await signUp();
                   if(response != null){
                     await FirebaseFirestore.instance.collection('users').add({
                           "user name" : myUserName,
                       "email" : myEmail,
                         });
                     Navigator.of(context).pushReplacement(MaterialPageRoute(
                         builder: (context)=>const HomeScreen()));
                   }else{
                     print("SignUp is failed ");
                   }
                  }, child: const Text("Sign Up")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


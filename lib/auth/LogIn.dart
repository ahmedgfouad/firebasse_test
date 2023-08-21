import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/auth/SignUp.dart';
import 'package:flutter/material.dart';

import '../ui/home.dart';

/*

ahmedgfouad2020@gmail.com
123456789hg

mohamed@gmail.com
1234567890hg
*/

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}



class _LogInScreenState extends  State<LogInScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  var myEmail,myPassword;

  logIN()async{
    // UserCredential userCredential;

    var formData = formState.currentState;
    if (formData!.validate()){
      formData.save();
      try {
         UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: myEmail,
          password: myPassword,
        );
         print("the email is ================${userCredential.user!.email}");
         return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('لا يوجد مستخدم لهذا الايميل ');
          // Navigator.pop(context);
        }
        else if (e.code == 'wrong-password') {
          print('كلمه المرور خاطئه ');
          // Navigator.pop(context);
        }
      }
    }
    else{
      print("Not Valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LogIn Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formState,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (val) {
                      myEmail = val;
                    },
                    onChanged: (val){
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
                    onChanged: (val){
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
                      const Text("If you don't have Account "),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()));
                          },
                          child: const Text("Sign Up")),
                    ],
                  ),
                  TextButton(
                      onPressed: () async{
                        UserCredential userInfo =await logIN();

                        if(userInfo != null){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context)=>const HomeScreen()));
                        }else {
                           print("user is null");
                        }

                      },
                      child: const Text("LogIn")),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

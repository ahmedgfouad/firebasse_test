import 'package:flutter/material.dart';

showLoading(context) {
  return showDialog(context: context, builder: (context)=> const AlertDialog(
    title: Text("Loading"),
    content: SizedBox(
        height: 50,width: 50,
        child: Center(child: CircularProgressIndicator())),
  ));
}
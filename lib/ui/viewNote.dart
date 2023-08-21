import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  Map? noteData ;
   ViewNote({Key? key,this.noteData}) : super(key: key);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View note page"),
      ),
      body: Column(
        children: [
          Image.network(widget.noteData!['image_url']),
          Text("${widget.noteData!['tittle']}"),
          Text("${widget.noteData!['notes']}"),
        ],
      ),
    );
  }
}


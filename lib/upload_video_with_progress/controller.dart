import 'package:flutter/cupertino.dart';

class UploadingVideoController extends ChangeNotifier{
  double? progress ;

  changeProgress(double progress){
    this.progress= progress;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class utils {
 void toastmessage(String text) {
  Fluttertoast.showToast(
      msg: "Failed to Enter into another Screen",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
 }
}
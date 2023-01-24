import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  final String title;
  final String detail;
  const TextWidget({Key? key, required this.title, required this.detail}) : super(key: key);

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${widget.title} : ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightBlueAccent),),
        SizedBox(height: 5,),
        Text("${widget.detail}  ",style: TextStyle(fontSize: 18,color: Colors.grey.shade700),)],
    );
  }
}
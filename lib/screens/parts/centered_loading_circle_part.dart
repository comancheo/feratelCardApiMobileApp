import 'package:flutter/material.dart';
Widget loadingCircle(){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height:100),
      Center(
        child: CircularProgressIndicator()
      )
    ],
  );
}
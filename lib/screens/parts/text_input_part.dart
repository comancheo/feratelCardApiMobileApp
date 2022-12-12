import 'package:flutter/material.dart';
class inputTextField{
  inputTextField({this.onSubmit, this.controller, this.obscureText, required this.label, this.hint, this.autofocus});
  Function? onSubmit = (_){};
  TextEditingController? controller;
  bool? obscureText = false;
  bool? autofocus = false;
  String label;
  String? hint="";
  Widget getWidget() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 15.0, right: 15.0, top: 15, bottom: 0),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        autofocus: this.autofocus??false,
        onSubmitted: (_){
          return this.onSubmit?.call(_);
        },
        controller: this.controller,
        obscureText: this.obscureText??false,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: this.label,
            hintText: this.hint),
      ),
    );
  }
}
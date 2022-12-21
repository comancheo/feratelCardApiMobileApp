import 'package:flutter/material.dart';
class inputTextField{
  inputTextField({this.onSubmit, this.controller, this.obscureText, required this.label, this.hint, this.autofocus, this.enabled, this.focusNode});
  Function? onSubmit = (_){};
  TextEditingController? controller;
  bool? obscureText = false;
  bool? autofocus = false;
  String label;
  String? hint="";
  bool? enabled;
  FocusNode? focusNode;
  Widget getWidget() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 15.0, right: 15.0, top: 15, bottom: 0),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        autofocus: this.autofocus??false,
        enabled: this.enabled,
        focusNode: this.focusNode,
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
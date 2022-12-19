import 'package:flutter/material.dart';
class dropDownInput{
  dropDownInput({required this.value, required this.items, required this.onChanged, required this.label});
  String value;
  List<DropdownMenuItem<String>> items;
  Function onChanged;
  String label;
  Widget getWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
      child:DropdownButtonFormField(
        value: this.value,
        items: this.items,
        decoration: InputDecoration(
          labelText: this.label,
          border: OutlineInputBorder(),
        ),
        onChanged:(_){
          this.onChanged.call(_);
        },
    ));
  }
}
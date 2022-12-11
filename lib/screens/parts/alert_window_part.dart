import 'package:flutter/material.dart';
class AlertWindow {
  AlertWindow({required this.context, this.show, this.type, this.message, this.color, this.title, this.icon})
      : assert(show != null), assert(type != null), assert(message != null), assert(color != null), assert(title != null), assert(icon != null);
  BuildContext context;
  bool? show = false;
  String? type;
  String? message;
  Color? color;
  String? title;
  IconData? icon;
  Widget getWidget(){
    if ((this.show??false)) {
      showDialog(
        context: context,
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          var ret = AlertDialog(
            insetPadding: EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            icon: Icon(this.icon),
            iconColor: Colors.white,
            backgroundColor: this.color,
            title: Text(this.title??""),
            content: Container(
              width: width * 0.5,
              height: height * 0.5,
              child: Text(this.message??"")
            ),
          );
          this.clearProperties();
          return ret;
        }
      );
    }
    return SizedBox.shrink();
  }
  clearProperties() {
    this.title = "";
    this.type = "error";
    this.show = false;
    this.icon = null;
    this.message = null;
    this.color = null;
  }
}
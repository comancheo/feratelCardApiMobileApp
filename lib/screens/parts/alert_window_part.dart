import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/routes/router.gr.dart';

class AlertWindow {
  AlertWindow({this.context,
    this.show,
    this.type,
    this.message,
    this.color,
    this.title,
    this.icon,
    this.route,
    this.widgetContent,
    this.runCallBack
  });

  BuildContext? context;
  bool? show = false;
  String? type;
  String? message;
  Widget? widgetContent;
  Color? color;
  String? title;
  IconData? icon;
  BuildContext?dialogContext;
  Function?runCallBack;
  dynamic route;

  popWindow() {
    this.closeDialog();
    if ((this.show != null) && (this.context != null)) {
      Future.delayed(Duration.zero, () {
        showDialog(
            context: this.context!,
            builder: (context) {
              this.dialogContext = context;
              var height = MediaQuery
                  .of(context)
                  .size
                  .height;
              var width = MediaQuery
                  .of(context)
                  .size
                  .width;
              var ret = AlertDialog(
                scrollable: true,
                insetPadding: EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                backgroundColor: this.color,
                actions: [
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: (this.color == Colors.redAccent)?Colors.white:Colors.redAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Center(child:Text(
                        'Ok',
                        style: TextStyle(color: (this.color == Colors.redAccent)?Colors.black:Colors.white, fontSize: 25),
                      )),
                    ),
                  )
                ],
                title: Row(children: [
                  Icon(
                    this.icon,
                    color: (this.color==Colors.white)?Colors.black:Colors.white,
                    size: 30,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 0.0),
                        blurRadius: 1.0,
                        color: Color.fromARGB(127, 0, 0, 0),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Flexible(
                      child: Text(this.title ?? "",
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: (this.color==Colors.white)?Colors.black:Colors.white,
                            fontSize: 30,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0.0, 0.0),
                                blurRadius: 1.0,
                                color: Color.fromARGB(127, 0, 0, 0),
                              ),
                            ],
                          ))),
                ]),
                content: Container(
                    width: width * 0.85,
                    height: height * 0.85,
                    constraints: BoxConstraints(
                      maxHeight:  height * 0.9,
                      minHeight:  height * 0.8,
                      maxWidth:  width * 0.9,
                      minWidth:  width * 0.8,
                    ),
                    child: SingleChildScrollView(child:Column(
                      children: this.getContent(),
                    ))),
              );
              this.clearProperties();
              if (this.runCallBack != null) {
                this.runCallBack!.call();
              }
              return ret;
            }).then((result) {
              if (this.runCallBack != null) {
                this.runCallBack!.call();
              }
              this.runCallBack = null;
              this.dialogContext = null;
        });
      });
    }
  }
  List<Widget> getContent() {
    List<Widget> content = [];
    if (this.message != null) {
      content.add(SizedBox(
        height: 50,
      ));
      content.add(Center(
          child: Text(
            this.message ?? "",
            style: TextStyle(
              color: (this.color==Colors.white)?Colors.black:Colors.white,
              fontSize: 25,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 1.0,
                  color: Color.fromARGB(127, 0, 0, 0),
                ),
              ],
            ),
          )));
    }
    if (this.widgetContent != null) {
      content.add(this.widgetContent!);
    }
    return content;
  }

  closeDialog(){
    if (this.dialogContext != null) {
      Navigator.pop(this.dialogContext!);
      this.dialogContext = null;
    }
  }
  clearProperties() {
    this.title = "";
    this.type = "error";
    this.show = false;
    this.icon = null;
    this.message = null;
    this.color = null;
    this.widgetContent = null;
  }
}

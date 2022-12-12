import 'package:flutter/material.dart';
class AlertWindow {
  AlertWindow({required this.context, this.show, this.type, this.message, this.color, this.title, this.icon});
  BuildContext context;
  bool? show = false;
  String? type;
  String? message;
  Color? color;
  String? title;
  IconData? icon;
  Widget getWidget(){
    if ((this.show??false)) {
      Future.delayed(Duration.zero,(){
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
              backgroundColor: this.color,
              title: Row(

                children:[
                  Icon(this.icon,color:Colors.white, size:30, shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 1.0,
                              color: Color.fromARGB(127,0, 0, 0),
                            ),
                          ],
                  ),
                  SizedBox(width: 30,),
                  Text(this.title??"",
                        style: TextStyle(color: Colors.white, fontSize: 30,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 1.0,
                              color: Color.fromARGB(127,0, 0, 0),
                            ),
                          ],
                        )
                  )
                ]
              ),
              content: Container(
                width: width * 0.5,
                height: height * 0.5,
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    Center(
                      child:Text(this.message??"",
                      style: TextStyle(color: Colors.white, fontSize: 25,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 1.0,
                              color: Color.fromARGB(127,0, 0, 0),
                            ),
                          ],),
                    )
                  )],
                )
              ),
            );
            this.clearProperties();
            return ret;
          }
        );
      });
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
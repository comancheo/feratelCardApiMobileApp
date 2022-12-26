import 'package:flutter/material.dart';
import 'package:jsqr/scanner.dart';
import '/util/communication.dart';
import '/screens/parts/parts.dart';
import '/routes/router.gr.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _DashboardScreen createState() => _DashboardScreen();
}
class _DashboardScreen extends State<DashboardScreen> {
  bool codeHandled = false;
  TextEditingController inputCodeController = TextEditingController();
  String? code;
  Future<bool>? camAvailableF;
  late FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    this.focusNode = FocusNode();
    focusNode!.addListener(this.focusHandler);
    camAvailableF = Scanner.cameraAvailable();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void deactivate(){
    super.deactivate();
    this.focusNode!.dispose();
  }
  focusHandler(){
    if (!this.focusNode!.hasFocus) {
      Communication().currentContext!;
      focusNode!.requestFocus();
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Communication().handleOnstartLoading(context:context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return this.body(context);
          } else {
            return loadingCircle();
          }
        }
        );
  }
  Widget body(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Akceptace karty: Akceptuj kartu",overflow: TextOverflow.clip,),
      ),
      drawer: DrawerPart(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...this.showBody(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openScan,
        tooltip: 'Skenuj QR',
        child: Icon(Icons.qr_code),
      ),
    );
  }

  void _openScan() async {
    var code =  showDialog(
        context: context,
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return AlertDialog(
            insetPadding: EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text('Načtěte kód'),
            content: Container(
              width: width * 0.5,
              height: height * 0.5,
              child: Scanner(),
            ),
          );
        });
    code.then((c){
      setState(() {
        this.code = this.inputCodeController.text = c;
        this.handleSubmitCode();
      });
    });
  }
  List<Widget> showBody(){
    List<Widget> members = [];
      members.add(
        Text(Communication().getCheckpointName(),style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
      );
      members.add(
        SizedBox(height:20)
      );
      members.add(
            FutureBuilder<bool>(
              future: camAvailableF,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Chyba: ${snapshot.error}");
                }
                if (snapshot.hasData) {
                  if (snapshot.data??false) {
                    return (Text("Můžete naskenovat kód kamerou"));
                  }
                  return (Text("Verze bez kamery"));
                } else {
                  return loadingCircle();
                }
              },
            ));
      members.add(
            inputTextField(
                label: "Číslo karty",
                hint: "Vložte číslo karty nebo ho naskenujte",
                autofocus: false,
                focusNode: this.focusNode,
                controller: this.inputCodeController,
                onSubmit: (_){
                  setState(() {
                    this.code = this.inputCodeController.text;
                    this.handleSubmitCode();
                  });
                }
            ).getWidget());
    return members;
  }
  Row messageTextTitle(text){
    return Row(children:[Flexible(child:Text(text,style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 1.0,
                  color: Color.fromARGB(127, 0, 0, 0),
                ),
              ],
            )))]);
  }
  Row messageText({required String text, String type = ""}){
    IconData icon = Icons.disc_full;
    if (type == "ok") {
      icon = Icons.check;
    } else if (type == "error"){
      icon = Icons.error;
    }
    return Row(children:[
      Icon(icon, color:Colors.white,size:20),
      SizedBox(width:20),
      Flexible(child:Text(text, textAlign: TextAlign.left, maxLines: 4, softWrap: true,style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 1.0,
                  color: Color.fromARGB(127, 0, 0, 0),
                ),
              ],
            )))]);
  }
  List<Row> serviceMessage(services){
    List<Row> message = [];
    for (var service in services){
      for(var translation in service["type"]["translations"]){
        String tmpMessage = "";
        if (service["valid"]) {
          tmpMessage = "";
        }
        if (translation['language'] == 'cs') {
          tmpMessage = tmpMessage+translation['name'];
          message.add(this.messageText(text:tmpMessage, type:(service['valid'])?"ok":"error"));
        }
      }
    }
    return message;
  }
  dynamic isCardValid() async {
    setState(() {
      this.codeHandled = true;
      Communication().popDialog(
            context: Communication().currentContext!,
            show: true,
            widgetContent: loadingCircle(),
            color: Colors.white,
            title: "Načítání",
            icon: Icons.downloading_sharp
          );
    });
    await Communication().checkCardValidity(this.code??"", (result){
      Map aP = {};
      bool ret = false;
      List<Row> message = [];"\n";
        if (result['card'] == "OK" && result['data']['valid'] == true) {
          ret = true;
          if (result["service"]!=null) {
            message = this.serviceMessage(result["service"]);
          }
          aP = {
            "message":null,
            "widgetContent": Column(children:message),
            "color": Colors.green,
            "title": "Karta přijata",
            "icon": Icons.check,
          };
        } else {
          if (result['card'] == "OK") {
            if (result["service"]!=null && result["service"].length > 0) {
              List<Row> messages = this.serviceMessage(result["service"]);
              for (Row m in messages) {
                message.add(m);
              }
            } else {
              message.add(this.messageTextTitle("Karta je platná, ale:"));
              for(var translation in result['data']['checkState']['translations']){
                //tick -> "✓"
                //cross -> "✓"
                String tmpMessage;
                if (translation['language'] == 'cs') {
                  tmpMessage = translation['name'];
                  message.add(this.messageText(text:tmpMessage));
                }
              }
            }
          } else{
            message.add(this.messageTextTitle("Karta není platná."));
          }
          aP = {
            "message": null,
            "widgetContent": Column(children:message),
            "color": Colors.redAccent,
            "title": "Karta nepřijata!",
            "icon": Icons.warning,
          };
        }
        setState(() {
          Communication().popDialog(
            context: Communication().currentContext!,
            show:true,
            widgetContent: aP["widgetContent"],
            message: aP["message"],
            color: aP["color"],
            title: aP["title"],
            icon: aP["icon"],
          );
          this.inputCodeController.text = "";
          this.code = "";
        });
        return ret;
    });
  }

  void handleSubmitCode() async {
    if (this.code == "") {
      return;
    }
    dynamic isValid = await this.isCardValid();
    return;
  }
}

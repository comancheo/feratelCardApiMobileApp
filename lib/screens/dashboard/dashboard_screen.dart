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
        if (result['card'] == "OK" && result['data']['valid'] == true) {
          ret = true;
          String message = "";
          for (var service in result['service']){
            for(var translation in service["type"]["translations"]){
              String tmpMessage;
              if (translation['language'] == 'cs') {
                tmpMessage = translation['name']+"\n";
                message = message + tmpMessage;
              }
            }
          }
          aP = {
            "message": "Karta je validní\n" + message,
            "color": Colors.green,
            "title": "Karta je validní",
            "icon": Icons.check,
          };
        } else {
          aP = {
            "message": "Karta není validní",
            "color": Colors.redAccent,
            "title": "Karta není validní",
            "icon": Icons.warning,
          };
        }
        setState(() {
          Communication().popDialog(
            context: Communication().currentContext!,
            show:true,
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

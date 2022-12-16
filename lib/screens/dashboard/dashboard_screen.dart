import 'package:flutter/material.dart';
import 'package:jsqr/scanner.dart';
import '/util/communication.dart';
import '/screens/parts/parts.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _DashboardScreen createState() => _DashboardScreen();
}
class _DashboardScreen extends State<DashboardScreen> {
  bool codeHandled = false;
  bool loading = false;
  TextEditingController inputCodeController = TextEditingController();
  String? code;
  AlertWindow? alertWindow;
  Future<bool>? camAvailableF;
  final Future<bool> startLoading = Communication().handleOnstartLoading();

  @override
  void initState() {
    super.initState();
    camAvailableF = Scanner.cameraAvailable();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AlertWindow alert = this.alertWindow??AlertWindow(context: context);
    return FutureBuilder<bool>(
        future: startLoading,
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
    if (this.loading) {
      members.add(loadingCircle());
    } else {
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
                  return CircularProgressIndicator();
                }
              },
            ));
      if(this.alertWindow!=null){
        members.add(this.alertWindow!.getWidget());
      }
      members.add(
            inputTextField(
                label: "Číslo karty",
                hint: "Vložte číslo karty nebo ho naskenujte",
                autofocus: true,
                controller: this.inputCodeController,
                onSubmit: (_){
                  setState(() {
                    this.code = this.inputCodeController.text;
                    this.handleSubmitCode();
                  });
                }
            ).getWidget());
    }
    return members;
  }
  bool isCardValid() {
    setState(() {
      this.codeHandled = true;
      this.loading = true;
    });
    return Communication().checkCardValidity(this.code??"", (result){
      AlertWindow alert = AlertWindow(context: context);
        if (result) {
          alert = AlertWindow(
            context: context,
            show: true,
            message: "Karta je validní",
            color: Colors.green,
            title: "Karta je validní",
            icon: Icons.check
          );
        } else {
          alert = AlertWindow(
            context: context,
            show: true,
            message: "Karta není validní",
            color: Colors.redAccent,
            title: "Karta není validní",
            icon: Icons.warning
          );
        }
        setState(() {
          this.alertWindow = alert;
          this.loading = false;
          this.inputCodeController.text = "";
        });
    });
  }

  void handleSubmitCode() async {
    if (this.code == "") {
      return;
    }
    bool isValid = await this.isCardValid();
  }
}

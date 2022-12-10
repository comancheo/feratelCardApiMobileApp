import 'package:flutter/material.dart';
import 'package:jsqr/scanner.dart';
import 'dart:html' as html;
import '/util/communication.dart';
import '/screens/parts/parts.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DashboardScreen createState() => _DashboardScreen();
}


class _DashboardScreen extends State<DashboardScreen> {
  final GlobalKey _inputCodeKey = GlobalKey<FormFieldState>();
  int counter = 0;
  bool codeHandled = false;
  TextEditingController inputCodeController = TextEditingController();
  String? code;
  FocusNode _focus = FocusNode();

  // Future<List<dynamic>> sourcesF;
  Future<bool>? camAvailableF;
  html.ImageElement? img;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    camAvailableF = Scanner.cameraAvailable();
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    if (_focus.hasFocus && this.codeHandled) {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akceptace karty: Akceptuj kartu"),
      ),
      drawer: DrawerPart(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              key: _inputCodeKey,
              focusNode: _focus,
              autofocus: true,
              controller: this.inputCodeController,
              decoration: const InputDecoration(
                 labelText: 'Číslo karty',
              ),
              onFieldSubmitted: (value) {
                setState(() {
                  this.code = value;
                });
                this.handleSubmitCode();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vložte kód';
                }
                return null;
              },
            ),
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
    var code = await showDialog(
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
    setState(() {
      this.code = this.inputCodeController.text = code;
    });
    this.handleSubmitCode();
  }

  bool isCardValid() {
    return Communication().checkCardValidity(this.code??"");
  }

  void handleSubmitCode() async {
    setState(() {
      this.codeHandled = true;
    });
    if (this.code == "") {
      return;
    }
    bool isValid = await this.isCardValid();

    if (isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Karta je validní!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Karta není validní!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '/routes/router.gr.dart';
import 'package:jsqr/scanner.dart';
import 'dart:html' as html;
import '/util/communication.dart';

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
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text('Domů'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                AutoRouter.of(context).push(const HomeRoute());
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('O aplikaci'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                AutoRouter.of(context).push(const AboutRoute());
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Akceptace karty'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                AutoRouter.of(context).push(const DashboardRoute());
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Přihlášení'),
              onTap: () {
                AutoRouter.of(context).push(
                    LoginRoute(
                      onLoginCallback: (_) {
                        AutoRouter.of(context).push(const DashboardRoute());
                      },
                    )
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
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

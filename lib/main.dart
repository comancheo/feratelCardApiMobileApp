import 'package:flutter/material.dart';
import 'package:jsqr/scanner.dart';
import 'dart:html' as html;
import 'package:oauth2_client/oauth2_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akceptace karty',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Akceptace karty'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _inputCodeKey = GlobalKey<FormFieldState>();
  int counter = 0;
  bool codeHandled = false;
  bool camAvailable = false;
  TextEditingController txt = TextEditingController();
  String code;
  String formMessage = "";
  FocusNode _focus = FocusNode();
  // Future<List<dynamic>> sourcesF;
  Future<bool> camAvailableF;
  html.ImageElement img;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    // sourcesF = navigator.mediaDevices.getSources();
    camAvailableF = Scanner.cameraAvailable();
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    if(_focus.hasFocus && this.codeHandled){
      setState(() {
        this.codeHandled = false;
        this.txt.text="";
      });
    }
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
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            title: const Text('Načtěte kód'),
            content: Container(
                width:width*0.5,
                height:height*0.5,
                child: Scanner(),
            ),
          );
        });
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (code) {
        this.code = code;
        this.txt.text = code;
        this.handleSubmitCode(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                  if (snapshot.data) {
                    this.camAvailable=true;
                    return (Text("Můžete naskenovat kód kamerou"));
                  }
                  this.camAvailable=false;
                  return (Text("Verze bez kamery"));
                } else {
                  this.camAvailable=false;
                  return CircularProgressIndicator();
                }
              },
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              key:_inputCodeKey,
              focusNode: _focus,
              autofocus: true,
              controller: this.txt,
              onFieldSubmitted: (value) {
                this.handleSubmitCode(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vložte kód';
                }
                return null;
              },
            ),
            Text(this.formMessage),
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
  void handleSubmitCode(code){
    setState(() {
      this.counter++;
      this.codeHandled = true;
    });
    if ((this.counter % 2)==0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Karta je validní!'), backgroundColor: Colors.green,),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Karta není validní!'), backgroundColor: Colors.redAccent,),
      );
    }
  }
}
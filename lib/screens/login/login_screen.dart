import 'package:flutter/material.dart';
import '/util/communication.dart';
import '/main.dart';
import '/screens/parts/parts.dart';
import 'package:auto_route/auto_route.dart';
import '/routes/router.gr.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, this.onLoginCallback}) : super(key: key);
  final Function(bool loggedIn)? onLoginCallback;

  @override
  _LoginScreen createState() =>
      _LoginScreen(onLoginCallback: this.onLoginCallback);
}

class _LoginScreen extends State<LoginScreen> {
  _LoginScreen({this.onLoginCallback});

  Function(bool loggedIn)? onLoginCallback;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController qrloginController = TextEditingController();
  String loginProgress = 'showForm';
  String error = "";
  final Future<bool> startLoading = Communication().handleOnstartLoading();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: startLoading,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text("Akceptace karty: Přihlášení"),
              ),
              drawer: DrawerPart(context),
              body: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: showBody()),
              ),
            );
          } else {
            return loadingCircle();
          }
        });
  }

  Form loginForm() {
    return Form(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
              child: Container(
                  width: 200,
                  height: 150,
                  /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                  child: Image.asset('assets/images/svazek-logo.png')),
            ),
          ),
          inputTextField(
            label: "Jméno",
            controller: this.usernameController,
            hint: "Vložte jméno",
            obscureText: false,
            onSubmit: (_) {
              this.handleSubmitLogin();
            },
          ).getWidget(),
          inputTextField(
              label: "Heslo",
              controller: this.passwordController,
              hint: "Vložte heslo",
              obscureText: true,
              onSubmit: (_) {
                this.handleSubmitLogin();
              }).getWidget(),
          inputTextField(
              label: "QRLogin",
              controller: this.qrloginController,
              hint: "Vložte text načtený z vašeho QR loginu",
              obscureText: true,
              onSubmit: (_) {
                this.handleSubmitLogin();
              }).getWidget(),
          SizedBox(height: 50),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20)),
            child: MaterialButton(
              onPressed: () {
                this.handleSubmitLogin();
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          SizedBox(
            height: 130,
          ),
        ],
      ),
    );
  }

  Widget errorText(String errorText) {
    return AlertWindow(
      show: true,
      context: context,
      color: Colors.redAccent,
      title: "Nepodařilo se Vás přihlásit",
      icon: Icons.warning,
      message: errorText,
    ).getWidget();
  }

  List<Widget> showBody() {
    List<Widget> members = [];
    if (this.error != "") {
      members.add(this.errorText(this.error));
      this.error = "";
    }
    if (this.loginProgress == "loading") {
      members.add(loadingCircle());
    }
    if (this.loginProgress == "showForm") {
      members.add(this.loginForm());
    }
    return members;
  }
  handleSubmitLogin() {
    if ((this.usernameController.text == "" ||
            this.passwordController.text == "") &&
        this.qrloginController == "") {
      return;
    }
    setState(() {
      this.loginProgress = "loading";
    });
    dynamic data = {
      "login": {
        "username": this.usernameController.text,
        "password": this.passwordController.text
      }
    };
    if (this.qrloginController.text != "") {
      dynamic tryUnbase =
          Communication().getLoginFromQRData(this.qrloginController.text);
      if (tryUnbase != false) {
        this.qrloginController.text = "";
        data = tryUnbase;
      }
    }
    Communication().logIn(data, (result) {
      var error = "";
      if (Communication().amILoggedIn()) {
        this.afterLogin();
      } else {
        error = "Špatné jméno nebo heslo!";
      }
      setState(() {
        this.loginProgress = 'showForm';
        this.error = error;
      });
    });
  }
  afterLogin(){
    Future.delayed(Duration.zero, () {
      setState(() {
        MyApp.of(context).authService.authenticated = Communication().amILoggedIn();
        onLoginCallback?.call(MyApp.of(context).authService.authenticated);
        if (onLoginCallback == null) {
          AutoRouter.of(context).push(DashboardRoute());
        }
      });
    });
  }
}

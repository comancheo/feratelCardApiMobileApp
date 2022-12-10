import 'package:example/util/communication.dart';
import 'package:flutter/material.dart';
import '/main.dart';
import '/screens/parts/parts.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, this.onLoginCallback})
      : super(key: key);
  Function(bool loggedIn)? onLoginCallback;
  @override
  _LoginScreen createState() => _LoginScreen(onLoginCallback:this.onLoginCallback);
}

class _LoginScreen extends State<LoginScreen> {
  _LoginScreen({this.onLoginCallback});
  Function(bool loggedIn)? onLoginCallback;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      drawer: DrawerPart(context),
      body: SingleChildScrollView(
        child: Form(
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
                      child: Image.asset('asset/images/flutter-logo.png')),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: this.usernameController,
                  onSubmitted: (_){
                    this.handleSubmitLogin();
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  onSubmitted: (_) {
                    this.handleSubmitLogin();
                  },
                  controller: this.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),
              SizedBox(height:50),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
                child: MaterialButton(
                  onPressed: () {
                    //TODO What to do after login
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
        ),
      ),
    );
  }
  handleSubmitLogin(){
    Communication().logIn({"login":{"username":this.usernameController.text, "password":this.passwordController.text}});
    if (Communication().amILoggedIn()) {
      MyApp.of(context).authService.authenticated = Communication().amILoggedIn();
      onLoginCallback?.call(MyApp.of(context).authService.authenticated);
    }
  }
}

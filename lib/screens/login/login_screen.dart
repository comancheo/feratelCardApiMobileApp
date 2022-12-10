import 'package:example/util/communication.dart';
import 'package:flutter/material.dart';
import '/main.dart';
import 'package:auto_route/auto_route.dart';
import '/routes/router.gr.dart';
/*
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key, required this.onLoginCallback})
      : super(key: key);

  final Function(bool loggedIn) onLoginCallback;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akceptace karty: Přihlášení"),
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
        child: TextButton(
            onPressed: () {
              if (Communication().amILoggedIn()) {
                MyApp.of(context).authService.authenticated = Communication().amILoggedIn();
                print("LOGGEDIN:"+Communication().amILoggedIn().toString());
                onLoginCallback.call(MyApp.of(context).authService.authenticated);
              }
            },
            child: const Text('Tap to login')),
      ),
    );
  }
}*/

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

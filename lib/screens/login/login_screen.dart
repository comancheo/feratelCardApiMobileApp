import 'package:example/util/communication.dart';
import 'package:flutter/material.dart';
import '/main.dart';
import 'package:auto_route/auto_route.dart';
import '/routes/router.gr.dart';

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
}

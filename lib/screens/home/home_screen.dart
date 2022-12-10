import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '/routes/router.gr.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akceptace karty"),
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
          children: [
            Text(
              'Aplikace pro akceptaci karet hosta a občana',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                  onPressed: () {
                    AutoRouter.of(context).push(const DashboardRoute());
                  },
                  child: Text(
                    'Akceptujte kartu',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    AutoRouter.of(context).push(const AboutRoute());
                  },
                  child: Text(
                    'O aplikaci',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

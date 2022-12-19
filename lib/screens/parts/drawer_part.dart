import 'package:example/util/communication.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/routes/router.gr.dart';
Drawer DrawerPart(context) {
  return Drawer(
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
                AutoRouter.of(context).push(HomeRoute());
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('O aplikaci'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                AutoRouter.of(context).push(AboutRoute());
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Akceptace karty'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                AutoRouter.of(context).push(DashboardRoute());
                Navigator.pop(context);
              },
            ),
            if (!Communication().amILoggedIn()) ListTile(
              title: const Text('Přihlášení'),
              onTap: () {
                AutoRouter.of(context).push(
                    LoginRoute(
                      onLoginCallback: (_) {
                        AutoRouter.of(context).push(DashboardRoute());
                      },
                    )
                );
                Navigator.pop(context);
              },
            ),
            if (Communication().amILoggedIn()) ListTile(
              title: const Text('QR pro přihlášení'),
              onTap: () {
                AutoRouter.of(context).push(
                    MyQRScreenRoute()
                );
                Navigator.pop(context);
              },
            ),
            if (Communication().storage.getItem("role")=="admin") ListTile(
              title: const Text('Uživatelé'),
              onTap: () {
                AutoRouter.of(context).push(
                    UsersRoute()
                );
                Navigator.pop(context);
              },
            ),
            if (Communication().amILoggedIn()) ListTile(
              title: const Text('Odhlásit se'),
              onTap: () {
                if (Communication().amILoggedIn()) {
                  Communication().logout((_){
                    //TODO what to do after logout
                  });
                }
                AutoRouter.of(context).push(
                    LoginRoute(
                      onLoginCallback: (_) {
                        AutoRouter.of(context).push(DashboardRoute());
                      },
                    )
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
}
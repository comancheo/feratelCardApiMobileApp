import 'dart:convert';

import 'package:example/util/communication.dart';
import 'package:flutter/material.dart';
import '/screens/parts/parts.dart';
import 'package:auto_route/auto_route.dart';
import '/routes/router.gr.dart';

class UsersScreen extends StatelessWidget {
  UsersScreen({Key? key}) : super(key: key);
  final Future<bool> startLoading = Communication().handleOnstartLoading();
  final Future<dynamic> users = Communication().getUsers();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: startLoading,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Akceptace karty: Uživatelé", overflow: TextOverflow.clip,),
                ),
                drawer: DrawerPart(context),
                body: Center(
                  child: FutureBuilder<dynamic>(
                    future:users,
                    builder: (context, snapshot){

                      if (snapshot.hasData) {
                        List<ListTile> usersTile = [];
                        dynamic data = snapshot.data!;
                        for(var user in data['users']){
                          usersTile.add(ListTile(
                            title: Text(user['username']),
                            subtitle: Text(user['checkpointName']),
                            onTap: () {
                              AutoRouter.of(context).push(UserRoute(user:user));
                              Navigator.pop(context);
                            }
                          ));
                        }
                        return ListView(
                          // Important: Remove any padding from the ListView.
                          padding: EdgeInsets.zero,
                          children: usersTile
                        );
                      }else{
                        return loadingCircle();
                      }
                    }
                  ),
                  ),
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  dynamic blankUser = {
                    "username":"",
                    "password":"",
                    "role":"user",
                    "checkpoint":"Akceptační místo"
                  };
                  AutoRouter.of(context).push(UserRoute(user:blankUser));
                  Navigator.pop(context);
                },
                tooltip: 'Přidej uživatele',
                child: Icon(Icons.add),
              ),
            );
          }else{
            return loadingCircle();
          }
        });
  }
}
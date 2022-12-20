import 'dart:js';

import 'package:example/util/communication.dart';
import 'package:flutter/material.dart';
import '/screens/parts/parts.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Communication().handleOnstartLoading(context: context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Akceptace karty: O Aplikaci", overflow: TextOverflow.clip,),
                ),
                drawer: DrawerPart(context),
                body: Center(
                  child: Text(
                    'Pro používání této aplikace budete potřebovat jméno a heslo. Kód můžete naskenovat kamerou, nebo čtečkou.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
            );
          }else{
            return loadingCircle();
          }
        });
  }
}

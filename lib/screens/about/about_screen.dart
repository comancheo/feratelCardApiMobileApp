import 'package:flutter/material.dart';
import '/screens/parts/parts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingBeforePart(body:Scaffold(
      appBar: AppBar(
        title: Text("Akceptace karty: O Aplikaci"),
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
    ));
  }
}

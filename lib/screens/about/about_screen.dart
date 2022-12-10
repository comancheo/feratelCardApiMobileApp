import 'package:flutter/material.dart';
import '/screens/parts/parts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akceptace karty: O Aplikaci"),
      ),
      drawer: DrawerPart(context),
      body: Center(
        child: Text(
          'This is our about screen',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      )
    );
  }
}

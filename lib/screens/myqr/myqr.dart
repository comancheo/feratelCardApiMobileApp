import 'package:flutter/material.dart';
import '/screens/parts/parts.dart';
import '/util/communication.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQRScreen extends StatelessWidget {
  MyQRScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Communication().handleOnstartLoading(context: context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Akceptace karty: Přihlašovací QR"),
                ),
                drawer: DrawerPart(context),
                body: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'Toto QR můžete použít pro rychlé přihlášení',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 50),
                      QrImage(
                        data: Communication().getLoginQRData(),
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ],
                  ),
                ));
          } else {
            return loadingCircle();
          }
        });
  }
}

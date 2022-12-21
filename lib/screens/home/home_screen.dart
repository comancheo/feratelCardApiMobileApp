import 'package:akceptace_karet_krajina_pod_snezkou/util/communication.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '/routes/router.gr.dart';
import '/screens/parts/parts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Communication().handleOnstartLoading(context: context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Akceptace karty"),
                ),
                drawer: DrawerPart(context),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      logoPart(),
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
                              AutoRouter.of(context).push(DashboardRoute());
                            },
                            child: Text(
                              'Akceptujte kartu',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              AutoRouter.of(context).push(AboutRoute());
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
          } else {
            return loadingCircle();
          }
    });
  }
}

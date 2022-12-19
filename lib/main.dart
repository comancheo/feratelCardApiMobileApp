import 'package:example/routes/router.gr.dart';
import 'package:example/util/communication.dart';
import 'package:flutter/material.dart';
import '/routes/route_guard.dart';
import '/routes/route_guard_admin.dart';
import '/util/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final authService = AuthService();
  late final _appRouter = AppRouter(routeGuard: RouteGuard(authService), routeGuardAdmin: RouteGuardAdmin(authService));
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: Communication().applicationKey,
      title: 'Akceptace karty',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate());
  }
}

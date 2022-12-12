// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

import '../screens/about/about_screen.dart' as _i5;
import '../screens/dashboard/dashboard_screen.dart' as _i3;
import '../screens/home/home_screen.dart' as _i2;
import '../screens/login/login_screen.dart' as _i1;
import '../screens/myqr/myqr.dart' as _i4;
import 'route_guard.dart' as _i8;

class AppRouter extends _i6.RootStackRouter {
  AppRouter({
    _i7.GlobalKey<_i7.NavigatorState>? navigatorKey,
    required this.routeGuard,
  }) : super(navigatorKey);

  final _i8.RouteGuard routeGuard;

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.LoginScreen(
          key: args.key,
          onLoginCallback: args.onLoginCallback,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomeScreen(),
      );
    },
    DashboardRoute.name: (routeData) {
      final args = routeData.argsAs<DashboardRouteArgs>(
          orElse: () => const DashboardRouteArgs());
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.DashboardScreen(
          key: args.key,
          title: args.title,
        ),
      );
    },
    MyQRScreenRoute.name: (routeData) {
      final args = routeData.argsAs<MyQRScreenRouteArgs>(
          orElse: () => const MyQRScreenRouteArgs());
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.MyQRScreen(key: args.key),
      );
    },
    AboutRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.AboutScreen(),
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          LoginRoute.name,
          path: '/login',
        ),
        _i6.RouteConfig(
          HomeRoute.name,
          path: '/',
        ),
        _i6.RouteConfig(
          DashboardRoute.name,
          path: '/dashboard',
          guards: [routeGuard],
        ),
        _i6.RouteConfig(
          MyQRScreenRoute.name,
          path: '/myqr',
          guards: [routeGuard],
        ),
        _i6.RouteConfig(
          AboutRoute.name,
          path: '/about',
        ),
      ];
}

/// generated route for
/// [_i1.LoginScreen]
class LoginRoute extends _i6.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i7.Key? key,
    dynamic Function(bool)? onLoginCallback,
  }) : super(
          LoginRoute.name,
          path: '/login',
          args: LoginRouteArgs(
            key: key,
            onLoginCallback: onLoginCallback,
          ),
        );

  static const String name = 'LoginRoute';
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.onLoginCallback,
  });

  final _i7.Key? key;

  final dynamic Function(bool)? onLoginCallback;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLoginCallback: $onLoginCallback}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.DashboardScreen]
class DashboardRoute extends _i6.PageRouteInfo<DashboardRouteArgs> {
  DashboardRoute({
    _i7.Key? key,
    String? title,
  }) : super(
          DashboardRoute.name,
          path: '/dashboard',
          args: DashboardRouteArgs(
            key: key,
            title: title,
          ),
        );

  static const String name = 'DashboardRoute';
}

class DashboardRouteArgs {
  const DashboardRouteArgs({
    this.key,
    this.title,
  });

  final _i7.Key? key;

  final String? title;

  @override
  String toString() {
    return 'DashboardRouteArgs{key: $key, title: $title}';
  }
}

/// generated route for
/// [_i4.MyQRScreen]
class MyQRScreenRoute extends _i6.PageRouteInfo<MyQRScreenRouteArgs> {
  MyQRScreenRoute({_i7.Key? key})
      : super(
          MyQRScreenRoute.name,
          path: '/myqr',
          args: MyQRScreenRouteArgs(key: key),
        );

  static const String name = 'MyQRScreenRoute';
}

class MyQRScreenRouteArgs {
  const MyQRScreenRouteArgs({this.key});

  final _i7.Key? key;

  @override
  String toString() {
    return 'MyQRScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.AboutScreen]
class AboutRoute extends _i6.PageRouteInfo<void> {
  const AboutRoute()
      : super(
          AboutRoute.name,
          path: '/about',
        );

  static const String name = 'AboutRoute';
}

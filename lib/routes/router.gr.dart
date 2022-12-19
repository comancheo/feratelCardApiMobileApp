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
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;

import '../screens/about/about_screen.dart' as _i5;
import '../screens/dashboard/dashboard_screen.dart' as _i3;
import '../screens/home/home_screen.dart' as _i2;
import '../screens/login/login_screen.dart' as _i1;
import '../screens/myqr/myqr.dart' as _i4;
import '../screens/user/user_screen.dart' as _i7;
import '../screens/users/users_screen.dart' as _i6;
import 'route_guard.dart' as _i10;
import 'route_guard_admin.dart' as _i11;

class AppRouter extends _i8.RootStackRouter {
  AppRouter({
    _i9.GlobalKey<_i9.NavigatorState>? navigatorKey,
    required this.routeGuard,
    required this.routeGuardAdmin,
  }) : super(navigatorKey);

  final _i10.RouteGuard routeGuard;

  final _i11.RouteGuardAdmin routeGuardAdmin;

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.LoginScreen(
          key: args.key,
          onLoginCallback: args.onLoginCallback,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i2.HomeScreen(key: args.key),
      );
    },
    DashboardRoute.name: (routeData) {
      final args = routeData.argsAs<DashboardRouteArgs>(
          orElse: () => const DashboardRouteArgs());
      return _i8.MaterialPageX<dynamic>(
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
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.MyQRScreen(key: args.key),
      );
    },
    AboutRoute.name: (routeData) {
      final args = routeData.argsAs<AboutRouteArgs>(
          orElse: () => const AboutRouteArgs());
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.AboutScreen(key: args.key),
      );
    },
    UsersRoute.name: (routeData) {
      final args = routeData.argsAs<UsersRouteArgs>(
          orElse: () => const UsersRouteArgs());
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.UsersScreen(key: args.key),
      );
    },
    UserRoute.name: (routeData) {
      final args =
          routeData.argsAs<UserRouteArgs>(orElse: () => const UserRouteArgs());
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.UserScreen(
          key: args.key,
          user: args.user,
        ),
      );
    },
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig(
          LoginRoute.name,
          path: '/login',
        ),
        _i8.RouteConfig(
          HomeRoute.name,
          path: '/',
        ),
        _i8.RouteConfig(
          DashboardRoute.name,
          path: '/dashboard',
          guards: [routeGuard],
        ),
        _i8.RouteConfig(
          MyQRScreenRoute.name,
          path: '/myqr',
          guards: [routeGuard],
        ),
        _i8.RouteConfig(
          AboutRoute.name,
          path: '/about',
        ),
        _i8.RouteConfig(
          UsersRoute.name,
          path: '/users',
          guards: [routeGuard],
        ),
        _i8.RouteConfig(
          UsersRoute.name,
          path: '/users',
          guards: [
            routeGuard,
            routeGuardAdmin,
          ],
        ),
        _i8.RouteConfig(
          UserRoute.name,
          path: '/edituser',
          guards: [
            routeGuard,
            routeGuardAdmin,
          ],
        ),
      ];
}

/// generated route for
/// [_i1.LoginScreen]
class LoginRoute extends _i8.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i9.Key? key,
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

  final _i9.Key? key;

  final dynamic Function(bool)? onLoginCallback;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLoginCallback: $onLoginCallback}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i8.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({_i9.Key? key})
      : super(
          HomeRoute.name,
          path: '/',
          args: HomeRouteArgs(key: key),
        );

  static const String name = 'HomeRoute';
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.DashboardScreen]
class DashboardRoute extends _i8.PageRouteInfo<DashboardRouteArgs> {
  DashboardRoute({
    _i9.Key? key,
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

  final _i9.Key? key;

  final String? title;

  @override
  String toString() {
    return 'DashboardRouteArgs{key: $key, title: $title}';
  }
}

/// generated route for
/// [_i4.MyQRScreen]
class MyQRScreenRoute extends _i8.PageRouteInfo<MyQRScreenRouteArgs> {
  MyQRScreenRoute({_i9.Key? key})
      : super(
          MyQRScreenRoute.name,
          path: '/myqr',
          args: MyQRScreenRouteArgs(key: key),
        );

  static const String name = 'MyQRScreenRoute';
}

class MyQRScreenRouteArgs {
  const MyQRScreenRouteArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'MyQRScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.AboutScreen]
class AboutRoute extends _i8.PageRouteInfo<AboutRouteArgs> {
  AboutRoute({_i9.Key? key})
      : super(
          AboutRoute.name,
          path: '/about',
          args: AboutRouteArgs(key: key),
        );

  static const String name = 'AboutRoute';
}

class AboutRouteArgs {
  const AboutRouteArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'AboutRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.UsersScreen]
class UsersRoute extends _i8.PageRouteInfo<UsersRouteArgs> {
  UsersRoute({_i9.Key? key})
      : super(
          UsersRoute.name,
          path: '/users',
          args: UsersRouteArgs(key: key),
        );

  static const String name = 'UsersRoute';
}

class UsersRouteArgs {
  const UsersRouteArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'UsersRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i7.UserScreen]
class UserRoute extends _i8.PageRouteInfo<UserRouteArgs> {
  UserRoute({
    _i9.Key? key,
    dynamic user,
  }) : super(
          UserRoute.name,
          path: '/edituser',
          args: UserRouteArgs(
            key: key,
            user: user,
          ),
        );

  static const String name = 'UserRoute';
}

class UserRouteArgs {
  const UserRouteArgs({
    this.key,
    this.user,
  });

  final _i9.Key? key;

  final dynamic user;

  @override
  String toString() {
    return 'UserRouteArgs{key: $key, user: $user}';
  }
}

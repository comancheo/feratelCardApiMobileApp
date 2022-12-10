// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i9;

import '../screens/about/about_screen.dart' as _i4;
import '../screens/dashboard/dashboard_screen.dart' as _i3;

import '../screens/home/home_screen.dart' as _i2;
import '../screens/login/login_screen.dart' as _i1;
import 'route_guard.dart' as _i10;

class AppRouter extends _i5.RootStackRouter {
  AppRouter(
      {_i9.GlobalKey<_i9.NavigatorState>? navigatorKey,
      required this.routeGuard})
      : super(navigatorKey);

  final _i10.RouteGuard routeGuard;

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i1.LoginScreen(
              key: args.key, onLoginCallback: args.onLoginCallback));
    },
    HomeRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.HomeScreen());
    },
    DashboardRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.DashboardScreen());
    },
    AboutRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.AboutScreen());
    },
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(LoginRoute.name, path: 'login'),
        _i5.RouteConfig(HomeRoute.name, path: '/'),
        _i5.RouteConfig(DashboardRoute.name, path: '/dashboard', guards: [
          routeGuard
        ],),
        _i5.RouteConfig(AboutRoute.name, path: '/about')
      ];
}

/// generated route for [_i1.LoginScreen]
class LoginRoute extends _i5.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({_i9.Key? key, dynamic Function(bool)? onLoginCallback})
      : super(name,
            path: 'login',
            args: LoginRouteArgs(key: key, onLoginCallback: onLoginCallback??(_){}));

  static const String name = 'LoginRoute';
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.onLoginCallback});

  final _i9.Key? key;

  final dynamic Function(bool)? onLoginCallback;
}

/// generated route for [_i2.HomeScreen]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute() : super(name, path: '/');

  static const String name = 'HomeRoute';
}

/// generated route for [_i3.DashboardScreen]
class DashboardRoute extends _i5.PageRouteInfo<void> {
  const DashboardRoute({List<_i5.PageRouteInfo>? children})
      : super(name, path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for [_i4.AboutScreen]
class AboutRoute extends _i5.PageRouteInfo<void> {
  const AboutRoute() : super(name, path: '/about');

  static const String name = 'AboutRoute';
}

/// generated route for [_i5.EmptyRouterPage]
class ProductsRoute extends _i5.PageRouteInfo<void> {
  const ProductsRoute({List<_i5.PageRouteInfo>? children})
      : super(name, path: 'products', initialChildren: children);

  static const String name = 'ProductsRoute';
}

/// generated route for [_i7.ProductsScreen]
class ProductsScreenRoute extends _i5.PageRouteInfo<void> {
  const ProductsScreenRoute() : super(name, path: '');

  static const String name = 'ProductsScreenRoute';
}

/// generated route for [_i8.AddProductsScreen]
class AddProductsRoute extends _i5.PageRouteInfo<void> {
  const AddProductsRoute() : super(name, path: 'add_products');

  static const String name = 'AddProductsRoute';
}

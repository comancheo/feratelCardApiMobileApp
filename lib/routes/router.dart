import 'package:auto_route/auto_route.dart';
import '/routes/route_guard.dart';
import '/screens/about/about_screen.dart';
import '/screens/dashboard/dashboard_screen.dart';
import '/screens/home/home_screen.dart';
import '/screens/login/login_screen.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: LoginScreen, name: 'LoginRoute', path: '/login'),
    AutoRoute(
      page: HomeScreen,
      name: 'HomeRoute',
      path: '/',
    ),
    AutoRoute(
      page: DashboardScreen,
      name: 'DashboardRoute',
      path: '/dashboard',
      guards: [RouteGuard],
    ),
    AutoRoute(page: AboutScreen, name: 'AboutRoute', path: '/about')
  ],
)
class $AppRouter {}

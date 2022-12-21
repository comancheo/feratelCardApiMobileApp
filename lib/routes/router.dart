import 'package:auto_route/auto_route.dart';
import 'package:akceptace_karet_krajina_pod_snezkou/screens/myqr/myqr.dart';
import '/routes/route_guard.dart';
import '/routes/route_guard_admin.dart';
import '/screens/about/about_screen.dart';
import '/screens/dashboard/dashboard_screen.dart';
import '/screens/home/home_screen.dart';
import '/screens/login/login_screen.dart';
import '/screens/users/users_screen.dart';
import '/screens/user/user_screen.dart';

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
    AutoRoute(
      page: MyQRScreen,
      name: 'MyQRScreenRoute',
      path: '/myqr',
      guards: [RouteGuard],
    ),
    AutoRoute(page: AboutScreen, name: 'AboutRoute', path: '/about'),
    AutoRoute(page: UsersScreen, name: 'UsersRoute', path: '/users',guards: [RouteGuard],),
    AutoRoute(page: UsersScreen, name: 'UsersRoute', path: '/users',guards: [RouteGuard,RouteGuardAdmin],),
    AutoRoute(page: UserScreen, name: 'UserRoute', path: '/edituser',guards: [RouteGuard,RouteGuardAdmin],)
  ],
)
class $AppRouter {}

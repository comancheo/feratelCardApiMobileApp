import 'package:auto_route/auto_route.dart';
import 'package:example/util/communication.dart';
import '/routes/router.gr.dart';
import '/util/auth_service.dart';

class RouteGuardAdmin extends AutoRedirectGuard {
  final AuthService authService;
  RouteGuardAdmin(this.authService) {
    authService.isAdmin = (Communication().storage.getItem("role")=="admin");
    authService.addListener(() {
      if (!authService.isAdmin) {
        // should be called when the logic effecting this guard changes
        // e.g when the user is no longer authenticated
        reevaluate();
      }
    });
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (authService.isAdmin) return resolver.next();
    router.push(
      HomeRoute(),
    );
  }

  @override

  Future<bool> canNavigate(RouteMatch route) {
    // TODO: implement canNavigate
    return Future.delayed(Duration.zero,(){
      return true;
    });
  }
}

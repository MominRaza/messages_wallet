import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: AccountsRoute.page),
        AutoRoute(page: AccountRoute.page),
        AutoRoute(page: PermissionRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ];
}

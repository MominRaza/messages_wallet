import 'package:go_router/go_router.dart';

import 'src/account/view/account_screen.dart';
import 'src/accounts/view/accounts_screen.dart';
import 'src/bank_support/view/bank_support_screen.dart';
import 'src/home/view/home_screen.dart';
import 'src/permissions/view/permission_screen.dart';
import 'src/settings/view/settings_screen.dart';
import 'src/shared/models/spending_model.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/accounts',
      builder: (context, state) => const AccountsScreen(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        return AccountScreen(
          title: extra['title'] as String,
          transactions: extra['transactions'] as List<Transaction>,
        );
      },
    ),
    GoRoute(
      path: '/permission',
      builder: (context, state) => const PermissionScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/bank-support',
      builder: (context, state) => const BankSupportScreen(),
    ),
  ],
);

// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i8;
import 'package:messages_wallet/src/account/view/account_screen.dart' as _i1;
import 'package:messages_wallet/src/accounts/view/accounts_screen.dart' as _i2;
import 'package:messages_wallet/src/home/view/home_screen.dart' as _i3;
import 'package:messages_wallet/src/permissions/view/permission_screen.dart'
    as _i4;
import 'package:messages_wallet/src/settings/view/settings_screen.dart' as _i5;
import 'package:messages_wallet/src/shared/models/spending_model.dart' as _i7;

/// generated route for
/// [_i1.AccountScreen]
class AccountRoute extends _i6.PageRouteInfo<AccountRouteArgs> {
  AccountRoute({
    required List<_i7.Transaction> transactions,
    required String title,
    _i8.Key? key,
    List<_i6.PageRouteInfo>? children,
  }) : super(
         AccountRoute.name,
         args: AccountRouteArgs(
           transactions: transactions,
           title: title,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AccountRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AccountRouteArgs>();
      return _i1.AccountScreen(
        transactions: args.transactions,
        title: args.title,
        key: args.key,
      );
    },
  );
}

class AccountRouteArgs {
  const AccountRouteArgs({
    required this.transactions,
    required this.title,
    this.key,
  });

  final List<_i7.Transaction> transactions;

  final String title;

  final _i8.Key? key;

  @override
  String toString() {
    return 'AccountRouteArgs{transactions: $transactions, title: $title, key: $key}';
  }
}

/// generated route for
/// [_i2.AccountsScreen]
class AccountsRoute extends _i6.PageRouteInfo<void> {
  const AccountsRoute({List<_i6.PageRouteInfo>? children})
    : super(AccountsRoute.name, initialChildren: children);

  static const String name = 'AccountsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.AccountsScreen();
    },
  );
}

/// generated route for
/// [_i3.HomeScreen]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomeScreen();
    },
  );
}

/// generated route for
/// [_i4.PermissionScreen]
class PermissionRoute extends _i6.PageRouteInfo<void> {
  const PermissionRoute({List<_i6.PageRouteInfo>? children})
    : super(PermissionRoute.name, initialChildren: children);

  static const String name = 'PermissionRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.PermissionScreen();
    },
  );
}

/// generated route for
/// [_i5.SettingsScreen]
class SettingsRoute extends _i6.PageRouteInfo<void> {
  const SettingsRoute({List<_i6.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.SettingsScreen();
    },
  );
}

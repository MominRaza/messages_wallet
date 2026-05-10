// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:collection/collection.dart' as _i10;
import 'package:flutter/material.dart' as _i9;
import 'package:messages_wallet/src/account/view/account_screen.dart' as _i1;
import 'package:messages_wallet/src/accounts/view/accounts_screen.dart' as _i2;
import 'package:messages_wallet/src/bank_support/view/bank_support_screen.dart'
    as _i3;
import 'package:messages_wallet/src/home/view/home_screen.dart' as _i4;
import 'package:messages_wallet/src/permissions/view/permission_screen.dart'
    as _i5;
import 'package:messages_wallet/src/settings/view/settings_screen.dart' as _i6;
import 'package:messages_wallet/src/shared/models/spending_model.dart' as _i8;

/// generated route for
/// [_i1.AccountScreen]
class AccountRoute extends _i7.PageRouteInfo<AccountRouteArgs> {
  AccountRoute({
    required List<_i8.Transaction> transactions,
    required String title,
    _i9.Key? key,
    List<_i7.PageRouteInfo>? children,
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

  static _i7.PageInfo page = _i7.PageInfo(
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

  final List<_i8.Transaction> transactions;

  final String title;

  final _i9.Key? key;

  @override
  String toString() {
    return 'AccountRouteArgs{transactions: $transactions, title: $title, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AccountRouteArgs) return false;
    return const _i10.ListEquality<_i8.Transaction>().equals(
          transactions,
          other.transactions,
        ) &&
        title == other.title &&
        key == other.key;
  }

  @override
  int get hashCode =>
      const _i10.ListEquality<_i8.Transaction>().hash(transactions) ^
      title.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i2.AccountsScreen]
class AccountsRoute extends _i7.PageRouteInfo<void> {
  const AccountsRoute({List<_i7.PageRouteInfo>? children})
    : super(AccountsRoute.name, initialChildren: children);

  static const String name = 'AccountsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.AccountsScreen();
    },
  );
}

/// generated route for
/// [_i3.BankSupportScreen]
class BankSupportRoute extends _i7.PageRouteInfo<void> {
  const BankSupportRoute({List<_i7.PageRouteInfo>? children})
    : super(BankSupportRoute.name, initialChildren: children);

  static const String name = 'BankSupportRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.BankSupportScreen();
    },
  );
}

/// generated route for
/// [_i4.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.HomeScreen();
    },
  );
}

/// generated route for
/// [_i5.PermissionScreen]
class PermissionRoute extends _i7.PageRouteInfo<void> {
  const PermissionRoute({List<_i7.PageRouteInfo>? children})
    : super(PermissionRoute.name, initialChildren: children);

  static const String name = 'PermissionRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.PermissionScreen();
    },
  );
}

/// generated route for
/// [_i6.SettingsScreen]
class SettingsRoute extends _i7.PageRouteInfo<void> {
  const SettingsRoute({List<_i7.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.SettingsScreen();
    },
  );
}

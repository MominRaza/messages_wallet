// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i8;
import 'package:messages_wallet/src/account/view/transactions_list_view.dart'
    as _i5;
import 'package:messages_wallet/src/accounts/view/messages_screen.dart' as _i2;
import 'package:messages_wallet/src/home/view/home_screen.dart' as _i1;
import 'package:messages_wallet/src/permissions/view/permission_screen.dart'
    as _i3;
import 'package:messages_wallet/src/settings/view/settings_screen.dart' as _i4;
import 'package:messages_wallet/src/shared/models/spending_model.dart' as _i7;

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomeScreen();
    },
  );
}

/// generated route for
/// [_i2.MessagesScreen]
class MessagesRoute extends _i6.PageRouteInfo<void> {
  const MessagesRoute({List<_i6.PageRouteInfo>? children})
      : super(
          MessagesRoute.name,
          initialChildren: children,
        );

  static const String name = 'MessagesRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.MessagesScreen();
    },
  );
}

/// generated route for
/// [_i3.PermissionScreen]
class PermissionRoute extends _i6.PageRouteInfo<void> {
  const PermissionRoute({List<_i6.PageRouteInfo>? children})
      : super(
          PermissionRoute.name,
          initialChildren: children,
        );

  static const String name = 'PermissionRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.PermissionScreen();
    },
  );
}

/// generated route for
/// [_i4.SettingsScreen]
class SettingsRoute extends _i6.PageRouteInfo<void> {
  const SettingsRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i5.TransactionsListView]
class TransactionsListView extends _i6.PageRouteInfo<TransactionsListViewArgs> {
  TransactionsListView({
    required List<_i7.Transaction> transactions,
    required String title,
    _i8.Key? key,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          TransactionsListView.name,
          args: TransactionsListViewArgs(
            transactions: transactions,
            title: title,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'TransactionsListView';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionsListViewArgs>();
      return _i5.TransactionsListView(
        transactions: args.transactions,
        title: args.title,
        key: args.key,
      );
    },
  );
}

class TransactionsListViewArgs {
  const TransactionsListViewArgs({
    required this.transactions,
    required this.title,
    this.key,
  });

  final List<_i7.Transaction> transactions;

  final String title;

  final _i8.Key? key;

  @override
  String toString() {
    return 'TransactionsListViewArgs{transactions: $transactions, title: $title, key: $key}';
  }
}

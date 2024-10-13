import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app_router.gr.dart';

@RoutePage()
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  late final AppLifecycleListener _listener;
  bool _shouldReload = false;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: () {
        if (_shouldReload) {
          _handleReadSMSPermission();
          setState(() => _shouldReload = false);
        }
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Spacer(
            flex: 2,
          ),
          Text(
            'Messages Wallet',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 28,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  'To use this app, you must grant permission to read SMS messages.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 12,
                ),
                Text('Messages are processed on your device only.'),
              ],
            ),
          ),
          const Spacer(),
          FilledButton.tonal(
            onPressed: _handleReadSMSPermission,
            child: const Text('Allow Read SMS Permission'),
          ),
          const Spacer(
            flex: 4,
          ),
        ],
      ),
    );
  }

  void _handleReadSMSPermission() {
    Permission.sms
        .onGrantedCallback(
      () => context.router.replace(const MessagesRoute()),
    )
        .onDeniedCallback(() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('SMS permission denied'),
        ),
      );
    }).onPermanentlyDeniedCallback(
      () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: const Text(
              'SMS permission permanently denied. Enable in settings.',
            ),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () {
                openAppSettings();
                setState(() => _shouldReload = true);
              },
            ),
          ),
        );
      },
    ).request();
  }
}

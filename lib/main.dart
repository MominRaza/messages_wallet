import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/accounts/view/messages_screen.dart';
import 'src/home/view/home_screen.dart';
import 'src/permissions/view/permission_screen.dart';
import 'src/settings/view/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messages Wallet',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      routes: {
        '/': (_) => const HomeScreen(),
        '/permission': (_) => const PermissionScreen(),
        '/messages': (_) => const MessagesScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}

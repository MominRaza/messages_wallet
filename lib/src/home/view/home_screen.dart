import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app_router.gr.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    (() async => await Permission.sms.isGranted && mounted
        ? context.router.replace(const MessagesRoute())
        : context.router.replace(const PermissionRoute()))();
  }

  @override
  Widget build(BuildContext _) => Scaffold(appBar: AppBar());
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

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
        ? context.go('/accounts')
        : context.go('/permission'))();
  }

  @override
  Widget build(BuildContext _) => Scaffold(appBar: AppBar());
}

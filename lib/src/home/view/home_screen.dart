import 'package:flutter/material.dart';
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
        ? Navigator.pushReplacementNamed(context, '/messages')
        : Navigator.pushReplacementNamed(context, '/permission'))();
  }

  @override
  Widget build(BuildContext _) => Scaffold(appBar: AppBar());
}

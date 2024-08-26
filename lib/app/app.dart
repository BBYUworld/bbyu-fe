import 'package:flutter/material.dart';
import '../views/home/home_view.dart';
import '../views/login/login_view.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: appTheme,
      home: LoginView(),

      debugShowCheckedModeBanner: false,
    );
  }
}
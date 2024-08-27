import 'package:flutter/material.dart';
import '../routes.dart';
import '../views/login/login_view.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GaGyeBBYU',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginView(),
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
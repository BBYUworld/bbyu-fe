import 'package:flutter/material.dart';
import '../views/login/login_view.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GaGye BBYU',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginView(),

      debugShowCheckedModeBanner: false,
    );
  }
}
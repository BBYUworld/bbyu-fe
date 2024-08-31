import 'package:flutter/material.dart';
import '../routes.dart';
import '../views/login/login_view.dart';
import 'package:gagyebbyu_fe/views/home/SplashScreen.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GaGyeBBYU',
      home: LoginView(),  // 커스텀 스플래시 화면을 첫 화면으로 설정
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
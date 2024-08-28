import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/LoanMainPage.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/LoanOverviewPage.dart';
import 'package:gagyebbyu_fe/views/loan/loan_loading_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/loan': (context) => LoanMainPage(),
  '/asset': (context) => LoanOverviewPage(),
  '/loading': (context) => LoanLoadingScreen(),
};
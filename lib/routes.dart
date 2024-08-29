import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/loan_main_page.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/assets_recommended_page.dart';
import 'package:gagyebbyu_fe/views/home/loading_page.dart';
import 'package:gagyebbyu_fe/views/loan/loan_loading_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/loan': (context) => LoanMainPage(),
  '/asset': (context) => LoanOverviewPage(),
  '/loading': (context) => LoanLoadingScreen(),
};
import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/LoanMainPage.dart';
import 'package:gagyebbyu_fe/views/fund/fund_view.dart';

final Map<String, WidgetBuilder> routes = {
  '/loan': (context) => LoanMainPage(),
  '/fund': (context) => FundView(),
};
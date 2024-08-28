import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/analysis/analysis_main_page.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/LoanMainPage.dart';
import 'package:gagyebbyu_fe/views/fund/fund_view.dart';


final Map<String, WidgetBuilder> routes = {
  '/loan': (context) => LoanMainPage(),
  '/fund': (context) => FundView(),
  '/report': (context) => AnalysisMainPage(),
};

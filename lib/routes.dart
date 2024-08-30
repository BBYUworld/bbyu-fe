import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/loan_main_page.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/assets_recommended_page.dart';
import 'package:gagyebbyu_fe/views/loan/couple_loan_recommended_page.dart';
import 'package:gagyebbyu_fe/views/fund/fund_view.dart';
import 'package:gagyebbyu_fe/views/loan/financial_product_page.dart';
import 'package:gagyebbyu_fe/views/loan/loan_loading_screen.dart';
import 'package:gagyebbyu_fe/views/analysis/analysis_main_page.dart';
final Map<String, WidgetBuilder> routes = {
  '/loan': (context) => LoanMainPage(),
  '/fund': (context) => FundView(),
  '/asset': (context) => AssetRecommendedPage(),
  '/loading': (context) => LoanLoadingScreen(),
  '/report': (context) => AnalysisMainPage(),
  '/couple': (context) => CoupleLoanRecommendationPage(),
  '/product': (context) => FinancialProductRecommendPage(),
};
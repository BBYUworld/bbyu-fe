import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/analysis/analysis_asset_main_page.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/loan_main_page.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/assets_recommended_page.dart';
import 'package:gagyebbyu_fe/views/fund/fund_view.dart';
import 'package:gagyebbyu_fe/views/loan/loan_loading_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/loan': (context) => LoanMainPage(),
  '/fund': (context) => FundView(),
  '/asset': (context) => AssetRecommendedPage(),
  '/loading': (context) => LoanLoadingScreen(),
  '/report': (context) => AnalysisAssetMainPage(),
};
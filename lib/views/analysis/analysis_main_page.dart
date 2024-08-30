import 'package:flutter/material.dart';
import '../../models/analysis/analysis_asset.dart';
import '../../services/analysis_api_service.dart';
import '../../widgets/analysis/asset_total_card.dart';
import '../../widgets/analysis/asset_category_card.dart';
import '../../widgets/analysis/asset_trend_card.dart';
import '../../widgets/analysis/asset_compare_card.dart';  // Import the AssetCompareCard widget

class AnalysisMainPage extends StatefulWidget {
  @override
  _AnalysisMainPage createState() => _AnalysisMainPage();
}

class _AnalysisMainPage extends State<AnalysisMainPage> {
  late Future<List<AssetCategoryDto>> futureAssetCategories;
  late Future<List<AnnualAssetDto>> futureAnnualAssets;
  late Future<AssetResultDto> futureAssetResult;

  @override
  void initState() {
    super.initState();
    futureAssetCategories = fetchAssetCategory();
    futureAnnualAssets = fetchAnnualAssets();
    futureAssetResult = fetchAssetResult();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('자산 분석'),
          bottom: TabBar(
            tabs: [
              Tab(text: '자산'),
              Tab(text: '소비'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAssetsTab(),
            Center(child: Text('소비 페이지 준비 중')),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TotalAssetsCard(futureAssetResult: futureAssetResult),
          SizedBox(height: 16.0),
          CategoryChartCard(futureAssetCategories: futureAssetCategories),
          SizedBox(height: 16.0),
          AssetsTrendCard(futureAnnualAssets: futureAnnualAssets),
          SizedBox(height: 16.0),
          FutureBuilder<AssetResultDto>(
            future: futureAssetResult,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data != null) {
                return AssetCompareCard(assetResult: snapshot.data!);
              } else {
                return Center(child: Text('데이터를 불러올 수 없습니다.'));
              }
            },
          ),
        ],
      ),
    );
  }
}

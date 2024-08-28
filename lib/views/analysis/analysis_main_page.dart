import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/analysis/analysis_asset.dart';
import '../../services/analysis_api_service.dart';

class AnalysisMainPage extends StatefulWidget {
  @override
  _AnalysisMainPage createState() => _AnalysisMainPage();
}

class _AnalysisMainPage extends State<AnalysisMainPage> {
  late Future<List<AnalysisAssetCategoryDto>> futureAssetCategories;
  late Future<AssetChangeRateDto> futureAssetChangeRate;
  late Future<AnalysisAssetResultDto> futureAssetResult;

  @override
  void initState() {
    super.initState();
    futureAssetCategories = fetchAssetCategories();
    futureAssetChangeRate = fetchAssetChangeRate();
    futureAssetResult = fetchAssetResult();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(  // DefaultTabController 추가
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
            _buildAssetsTab(),  // 자산 탭 내용
            Center(child: Text('소비 페이지 준비 중')),  // 소비 탭 내용
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
          // 총 자산 섹션
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '총자산',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  FutureBuilder<AnalysisAssetResultDto>(
                    future: futureAssetResult,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${snapshot.data!.coupleTotalAssets.toStringAsFixed(0)}원',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  '▲ 18,500원',
                                  style: TextStyle(color: Colors.red, fontSize: 16),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  '2024.08.21 15:00 기준',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Text('데이터를 불러오지 못했습니다.');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          // 통계 섹션
          FutureBuilder<List<AnalysisAssetCategoryDto>>(
            future: futureAssetCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                // 섹션 값이 0인 항목 필터링
                final nonZeroSections = snapshot.data!.where((data) => data.percentage > 0).toList();

                if (nonZeroSections.isEmpty) {
                  return Center(child: Text('No data available'));
                }

                // 색상 목록 생성
                final List<Color> colors = [
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.purple,
                ];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '통계',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                        // 원형 차트
                        Center(
                          child: Container(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: List.generate(nonZeroSections.length, (index) {
                                  final data = nonZeroSections[index];
                                  return PieChartSectionData(
                                    color: colors[index % colors.length], // 순환하며 색상 적용
                                    value: data.percentage,
                                    title: '${data.percentage}%',
                                    radius: 50,
                                  );
                                }),
                                centerSpaceRadius: 40,
                                sectionsSpace: 0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        // 각 자산 항목
                        Column(
                          children: nonZeroSections.map((data) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data.label.toString().split('.').last), // enum 값을 String으로 변환
                                  Text('${data.amount}원'),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Text('데이터를 불러오지 못했습니다.');
              }
            },
          ),
          SizedBox(height: 16.0),
          // 총 자산 추이 섹션
          FutureBuilder<AssetChangeRateDto>(
            future: futureAssetChangeRate,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '총 자산 추이',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                        // 추이 그래프 - 외부 라이브러리로 구현
                        Container(
                          height: 150,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: true),
                              titlesData: FlTitlesData(
                                leftTitles: SideTitles(showTitles: true),
                                bottomTitles: SideTitles(showTitles: true),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 1),
                                    FlSpot(1, 2),
                                    FlSpot(2, 1.5),
                                    FlSpot(3, 2.5),
                                  ],
                                  isCurved: true,
                                  colors: [Colors.blue],
                                  barWidth: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          '"작년에 비해 자산이 ${snapshot.data!.totalChangeRate}% 늘었어요"',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Text('데이터를 불러오지 못했습니다.');
              }
            },
          ),
        ],
      ),
    );
  }
}

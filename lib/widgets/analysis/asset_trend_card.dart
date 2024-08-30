import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/analysis/analysis_asset.dart';
import '../../utils/asset_category_color_mapping.dart'; // assetColorMapping import

class AssetsTrendCard extends StatelessWidget {
  final Future<List<AnnualAssetDto>> futureAnnualAssets;

  AssetsTrendCard({required this.futureAnnualAssets});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AnnualAssetDto>>(
      future: futureAnnualAssets,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
          final data = snapshot.data!;
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
                    '자산 추이',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: SideTitles(showTitles: true),
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTitles: (value) {
                              if (value.toInt() < data.length) {
                                return data[value.toInt()].year.toString();
                              } else {
                                return 'Current';
                              }
                            },
                          ),
                        ),
                        lineBarsData: [
                          _buildLineChartBarData(
                            color: assetColorMapping['ACCOUNT']!,
                            spots: data.asMap().entries.map((entry) {
                              int index = entry.key;
                              return FlSpot(index.toDouble(), entry.value.accountAssets ?? 0);
                            }).toList(),
                            title: "ACCOUNT",
                          ),
                          _buildLineChartBarData(
                            color: assetColorMapping['STOCK']!,
                            spots: data.asMap().entries.map((entry) {
                              int index = entry.key;
                              return FlSpot(index.toDouble(), entry.value.stockAssets ?? 0);
                            }).toList(),
                            title: "STOCK",
                          ),
                          _buildLineChartBarData(
                            color: assetColorMapping['REAL_ESTATE']!,
                            spots: data.asMap().entries.map((entry) {
                              int index = entry.key;
                              return FlSpot(index.toDouble(), entry.value.realEstateAssets ?? 0);
                            }).toList(),
                            title: "Real Estate",
                          ),
                          _buildLineChartBarData(
                            color: assetColorMapping['LOAN']!,
                            spots: data.asMap().entries.map((entry) {
                              int index = entry.key;
                              return FlSpot(index.toDouble(), entry.value.loanAssets ?? 0);
                            }).toList(),
                            title: "Loan",
                          ),
                          _buildLineChartBarData(
                            color: assetColorMapping['TOTAL']!,
                            spots: data.asMap().entries.map((entry) {
                              int index = entry.key;
                              return FlSpot(index.toDouble(), entry.value.totalAssets ?? 0);
                            }).toList(),
                            title: "Total",
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.blueAccent,
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((LineBarSpot touchedSpot) {
                                String category;
                                switch (touchedSpot.barIndex) {
                                  case 0:
                                    category = "ACCOUNT";
                                    break;
                                  case 1:
                                    category = "STOCK";
                                    break;
                                  case 2:
                                    category = "Real Estate";
                                    break;
                                  case 3:
                                    category = "Loan";
                                    break;
                                  case 4:
                                    category = "Total";
                                    break;
                                  default:
                                    category = "Unknown";
                                }
                                return LineTooltipItem(
                                  '$category: ${touchedSpot.y}',
                                  const TextStyle(color: Colors.white),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          );
        } else {
          return Text('데이터를 불러오지 못했습니다.');
        }
      },
    );
  }

  LineChartBarData _buildLineChartBarData({
    required Color color,
    required List<FlSpot> spots,
    required String title,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [color],
      barWidth: 4,
      belowBarData: BarAreaData(show: false),
      dotData: FlDotData(show: true),
    );
  }
}

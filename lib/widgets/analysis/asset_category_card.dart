import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/analysis/analysis_asset.dart';
import '../../utils/asset_label_mapping.dart';
import '../../utils/asset_category_color_mapping.dart';
import '../../utils/currency_formatting.dart';

class CategoryChartCard extends StatefulWidget {
  final Future<List<AssetCategoryDto>> futureAssetCategories;

  CategoryChartCard({required this.futureAssetCategories});

  @override
  _CategoryChartCardState createState() => _CategoryChartCardState();
}

class _CategoryChartCardState extends State<CategoryChartCard> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<AssetCategoryDto>>(
          future: widget.futureAssetCategories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final nonZeroSections = snapshot.data!.where((data) => data.percentage > 0).toList();

              if (nonZeroSections.isEmpty) {
                return Center(child: Text('No data available'));
              }

              final sections = nonZeroSections.map((data) {
                final labelKey = data.label.toString().split('.').last;
                final color = assetColorMapping[labelKey] ?? Colors.grey; // 매핑된 색상 사용
                return PieChartSectionData(
                  color: color,
                  value: data.percentage,
                  title: '${data.percentage}%',
                  radius: 50,
                );
              }).toList();

              final labels = nonZeroSections.map((data) {
                final labelKey = data.label.toString().split('.').last;
                return assetLabelMapping[labelKey] ?? labelKey; // 매핑된 라벨 사용
              }).toList();

              final amounts = nonZeroSections.map((data) => data.amount).toList(); // amounts를 int로 유지

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '통계',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: Container(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (PieTouchResponse? pieTouchResponse) {
                              setState(() {
                                if (pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          sections: List.generate(sections.length, (index) {
                            final isTouched = index == touchedIndex;
                            final double fontSize = isTouched ? 25.0 : 16.0;
                            final double radius = isTouched ? 60.0 : 50.0;
                            final data = sections[index];
                            final label = labels[index];
                            return PieChartSectionData(
                              color: data.color,
                              value: data.value,
                              title: isTouched ? label : '${data.value}%', // 터치되면 라벨만 표시
                              radius: radius,
                              titleStyle: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xffffffff),
                              ),
                              titlePositionPercentageOffset: 0.55,
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
                    children: List.generate(sections.length, (index) {
                      final data = sections[index];
                      final color = data.color;
                      final label = labels[index];
                      final amount = amounts[index]; // amount는 int

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('$label ${data.value}%'),
                              ],
                            ),
                            Text('${formatCurrency(amount)}원'),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              );
            } else {
              return Text('데이터를 불러오지 못했습니다.');
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/analysis/analysis_expense.dart';
import '../../models/expense/expense_category.dart';
import '../../utils/currency_formatting.dart';
import '../../utils/expense_category_color_mapping.dart';
import '../../utils/expense_label_mapping.dart'; // expenseLabelMapping 가져오기

class CategoryChartCard extends StatefulWidget {
  final Future<List<ExpenseCategoryDto>> futureExpenseCategories;

  CategoryChartCard({required this.futureExpenseCategories});

  @override
  _CategoryChartCardState createState() => _CategoryChartCardState();
}

class _CategoryChartCardState extends State<CategoryChartCard> {
  int touchedIndex = -1;

  String getMappedLabel(String label) {
    return expenseLabelMapping[label] ?? label;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<ExpenseCategoryDto>>(
          future: widget.futureExpenseCategories,
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
                final color = expenseColorMapping[categoryFromString(data.label)] ?? Colors.grey; // Category 객체로 색상 매핑

                return PieChartSectionData(
                  color: color,
                  value: data.percentage,
                  title: '${data.percentage}%',
                  radius: 50,
                );
              }).toList();

              final labels = nonZeroSections.map((data) {
                final label = data.label.toString(); // Category 객체를 String으로 변환
                return getMappedLabel(label);
              }).toList();

              final amounts = nonZeroSections.map((data) => data.amount).toList();

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
                            final double fontSize = isTouched ? 18.0 : 12.0;
                            final double radius = isTouched ? 70.0 : 50.0;
                            final data = sections[index];
                            final label = labels[index];
                            return PieChartSectionData(
                              color: data.color,
                              value: data.value,
                              title: isTouched ? label : '${data.value}%',
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
                  Column(
                    children: List.generate(sections.length, (index) {
                      final data = sections[index];
                      final color = data.color;
                      final label = labels[index];
                      final amount = amounts[index];

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

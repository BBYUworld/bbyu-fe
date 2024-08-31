// transaction_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gagyebbyu_fe/models/fund/fund_overview.dart';
import 'package:gagyebbyu_fe/models/fund/fund_transaction.dart';
import 'package:intl/intl.dart';

class TransactionChart extends StatelessWidget {
  final FundOverview fundOverview;
  final List<FundTransaction> fundTransactions;

  TransactionChart({required this.fundOverview, required this.fundTransactions});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFF9FAFB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('펀드 거래 내역', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Container(
              height: 300,
              child: LineChart(
                LineChartData(
                  backgroundColor : Color(0xFFF9FAFB),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: fundOverview.targetAmount / 5,
                      getTitles: (value) {
                        return _formatCurrency(value.toInt());
                      },
                    ),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        int index = value.toInt();
                        List<DateTime> sortedDates = _getSortedDates(fundOverview, fundTransactions);

                        if (index < sortedDates.length) {
                          return DateFormat('MM/dd').format(sortedDates[index]);
                        }
                        return '';
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateDataPoints(fundOverview, fundTransactions),
                      isCurved: true,
                      colors: [Color(0xFFFF6B6B)],
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  minY: 0,
                  maxY: fundOverview.targetAmount.toDouble(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _getSortedDates(FundOverview fundOverview, List<FundTransaction> transactions) {
    Map<DateTime, double> dateToAmountMap = {};

    DateTime startDate = DateTime(fundOverview.startDate.year, fundOverview.startDate.month, fundOverview.startDate.day);
    dateToAmountMap[startDate] = 0;

    for (var transaction in transactions) {
      DateTime date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      if (dateToAmountMap.containsKey(date)) {
        dateToAmountMap[date] = dateToAmountMap[date]! + transaction.amount.toDouble();
      } else {
        dateToAmountMap[date] = transaction.amount.toDouble();
      }
    }

    return dateToAmountMap.keys.toList()..sort();
  }

  List<FlSpot> _generateDataPoints(FundOverview fundOverview, List<FundTransaction> transactions) {
    Map<DateTime, double> dateToAmountMap = {};

    DateTime startDate = DateTime(fundOverview.startDate.year, fundOverview.startDate.month, fundOverview.startDate.day);
    dateToAmountMap[startDate] = 0;

    for (var transaction in transactions) {
      DateTime date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      if (dateToAmountMap.containsKey(date)) {
        dateToAmountMap[date] = dateToAmountMap[date]! + transaction.amount.toDouble();
      } else {
        dateToAmountMap[date] = transaction.amount.toDouble();
      }
    }

    double cumulativeAmount = 0;
    List<FlSpot> dataPoints = [];
    List<DateTime> sortedDates = dateToAmountMap.keys.toList()..sort();

    for (int i = 0; i < sortedDates.length; i++) {
      cumulativeAmount += dateToAmountMap[sortedDates[i]]!;
      dataPoints.add(FlSpot(i.toDouble(), cumulativeAmount));
    }

    return dataPoints;
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원');
    return formatter.format(amount);
  }
}
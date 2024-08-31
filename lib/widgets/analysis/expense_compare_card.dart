import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/analysis/analysis_expense.dart';
import '../../utils/currency_formatting.dart';

class ExpenseCompareCard extends StatelessWidget {
  final ExpenseResultDto? expenseResult;

  ExpenseCompareCard({required this.expenseResult});

  @override
  Widget build(BuildContext context) {
    // expenseResult가 null이거나 데이터가 유효하지 않으면 No Data View 반환
    if (expenseResult == null || _hasInvalidData(expenseResult!)) {
      return _buildNoDataView();
    }

    int anotherCoupleMonthExpenseAvg = expenseResult!.anotherCoupleMonthExpenseAvg;

    double percentageChange = _calculatePercentageChange(
      expenseResult!.coupleMonthExpense,
      anotherCoupleMonthExpenseAvg,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '지출 분석',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                text: '또래 대비 지출 ',
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: '${percentageChange > 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: percentageChange > 0 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            Row(
              children: [
                _buildTag('${expenseResult!.startAge}대'),
                SizedBox(width: 8.0),
                _buildTag('${expenseResult!.startIncome}만원대'),
              ],
            ),
            SizedBox(height: 12.0),
            Divider(),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildComparisonColumn('또래 평균', '${formatCurrency(anotherCoupleMonthExpenseAvg)}원'),
                Text('VS', style: TextStyle(fontSize: 16, color: Colors.grey)),
                _buildComparisonColumn('우리의 지출', '${formatCurrency(expenseResult!.coupleMonthExpense)}원'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculatePercentageChange(int coupleMonthExpense, int anotherCoupleMonthExpenseAvg) {
    if (anotherCoupleMonthExpenseAvg == 0) return 0;
    return ((coupleMonthExpense - anotherCoupleMonthExpenseAvg) / anotherCoupleMonthExpenseAvg) * 100;
  }

  bool _hasInvalidData(ExpenseResultDto result) {
    // 지출 데이터가 모두 0일 때 유효하지 않은 데이터로 간주
    return result.coupleMonthExpense == 0 && result.anotherCoupleMonthExpenseAvg == 0;
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 12.0),
      ),
    );
  }

  Widget _buildComparisonColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            '지출 데이터가 없습니다.',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

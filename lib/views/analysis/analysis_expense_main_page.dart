import 'package:flutter/material.dart';
import '../../models/analysis/analysis_expense.dart';
import '../../models/expense/couple_expense_model.dart';
import '../../services/analysis_api_service.dart';
import '../../widgets/analysis/expense_compare_card.dart';
import '../../widgets/analysis/expense_category_card.dart';
import '../../widgets/expense/joint_ledger_header.dart';

class AnalysisExpenseMainPage extends StatefulWidget {
  final CoupleExpense? coupleExpense;
  final Future<void> Function(int year, int month) onRefresh;
  final int currentYear;
  final int currentMonth;
  final void Function(int year, int month) onMonthChanged; // year, month 방식으로 변경

  AnalysisExpenseMainPage({
    required this.coupleExpense,
    required this.onRefresh,
    required this.currentYear,
    required this.currentMonth,
    required this.onMonthChanged,
  });

  @override
  _AnalysisExpenseMainPage createState() => _AnalysisExpenseMainPage();
}

class _AnalysisExpenseMainPage extends State<AnalysisExpenseMainPage> {
  late Future<List<ExpenseCategoryDto>> futureExpenseCategories;
  late Future<ExpenseResultDto> futureExpenseResult;

  @override
  void initState() {
    super.initState();
    futureExpenseCategories = fetchExpenseCategory(widget.currentYear, widget.currentMonth);
    futureExpenseResult = fetchExpenseResult(widget.currentYear, widget.currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          JointLedgerHeader(
            coupleExpense: widget.coupleExpense,
            displayedYear: widget.currentYear,
            displayedMonth: widget.currentMonth,
            onMonthChanged: (increment) {
              // 월 변경 로직
              int newYear = widget.currentYear;
              int newMonth = widget.currentMonth + increment;
              if (newMonth > 12) {
                newMonth = 1;
                newYear++;
              } else if (newMonth < 1) {
                newMonth = 12;
                newYear--;
              }
              widget.onMonthChanged(newYear, newMonth);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryChartCard(futureExpenseCategories: futureExpenseCategories),
                  SizedBox(height: 16.0),
                  FutureBuilder<ExpenseResultDto>(
                    future: futureExpenseResult,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return ExpenseCompareCard(expenseResult: snapshot.data!);
                      } else {
                        return Center(child: Text('데이터를 불러올 수 없습니다.'));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

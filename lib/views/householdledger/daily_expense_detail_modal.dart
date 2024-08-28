import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/couple_expense_model.dart';

class DailyExpenseDetailModal extends StatelessWidget {
  final DateTime date;
  final List<DailyDetailExpense> expenses;

  DailyExpenseDetailModal({required this.date, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${date.month}월 ${date.day}일 ${_getWeekdayName(date.weekday)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '총 ${expenses.length}건 -${_calculateTotalExpense()}원',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.store, color: Colors.black),
                  ),
                  title: Text(expense.memo ?? '설명 없음'),
                  subtitle: Text(expense.category ?? '카테고리 없음'),
                  trailing: Text(
                    '-${expense.amount.abs()}원',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekdayName(int weekday) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[weekday - 1];
  }

  int _calculateTotalExpense() {
    return expenses.fold(0, (sum, expense) => sum + expense.amount.abs());
  }
}
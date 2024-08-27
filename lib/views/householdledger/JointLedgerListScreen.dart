import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/couple_expense_model.dart';

class JointLedgerListScreen extends StatefulWidget {
  final CoupleExpense? coupleExpense;
  final Function(int year, int month) onRefresh;

  JointLedgerListScreen({required this.coupleExpense, required this.onRefresh});

  @override
  _JointLedgerListScreenState createState() => _JointLedgerListScreenState();
}

class _JointLedgerListScreenState extends State<JointLedgerListScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: () async {
            final now = DateTime.now();
            await widget.onRefresh(now.year, now.month);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildAccountInfo(),
              ),
              SliverList(
                delegate: SliverChildListDelegate(_buildExpenseList(constraints)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '지출 총액: - ${widget.coupleExpense?.totalAmount ?? 0}원',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '한달 목표 지출: ${widget.coupleExpense?.targetAmount ?? 0}원',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                '차이: ${widget.coupleExpense?.amountDifference ?? 0}원',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpenseList(BoxConstraints constraints) {
    if (widget.coupleExpense == null || widget.coupleExpense!.expenses.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: SizedBox(
            height: constraints.maxHeight - 200, // Adjust this value as needed
            child: Center(
              child: Text('현재 지출 내역이 없습니다.'),
            ),
          ),
        ),
      ];
    }

    return widget.coupleExpense!.expenses.map((expense) {
      return ListTile(
        title: Text(expense.date),
        trailing: Text(
          '-${expense.totalAmount}원',
          style: TextStyle(color: Colors.red),
        ),
      );
    }).toList();
  }
}
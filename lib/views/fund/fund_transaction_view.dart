import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/fund/fund_overview.dart';
import 'package:gagyebbyu_fe/models/fund/fund_transaction.dart';
import 'package:intl/intl.dart';

class FundTransactionView extends StatelessWidget {
  final List<FundTransaction> transactions;
  final FundOverview fundOverview;

  FundTransactionView({required this.transactions, required this.fundOverview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fundOverview.goal),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          _buildHeader(fundOverview),
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(FundOverview fundOverview) {
    return Container(
      color: Colors.pinkAccent,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fundOverview.goal,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _formatCurrency(fundOverview.currentAmount),
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeaderButton('충전하기'),
              _buildHeaderButton('긴급출금'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.pinkAccent,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(text),
    );
  }

  Widget _buildTransactionList() {

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final bool showDate = index == 0 ||
            !_isSameDate(transaction.date, transactions[index - 1].date);

        return _buildTransactionItem(transaction, showDate);
      },
    );
  }

  Widget _buildTransactionItem(FundTransaction transaction, bool showDate) {
    bool isIncome = transaction.type == 'PLUS';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDate)
            Text(
              _formatDate(transaction.date),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    transaction.type,
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    (isIncome ? '+' : '-') + _formatCurrency(transaction.amount.abs()),
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatCurrency(transaction.currentAmount),  // 누적 금액
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(thickness: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원');
    return formatter.format(amount);
  }

  String _formatDate(DateTime date) {
    return '${date.year % 100}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

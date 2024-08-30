import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/fund/fund_overview.dart';
import 'package:gagyebbyu_fe/models/fund/fund_transaction.dart';
import 'package:gagyebbyu_fe/views/fund/fund_charge_view.dart';
import 'package:intl/intl.dart';
import 'fund_emergency_withdrawal_view.dart';

class FundTransactionView extends StatelessWidget {
  final List<FundTransaction> transactions;
  final FundOverview fundOverview;

  FundTransactionView({required this.transactions, required this.fundOverview});

  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(fundOverview.goal, style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: Column(
        children: [
          _buildHeader(context, fundOverview),
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FundOverview fundOverview) {
    return Container(
      color: _cardColor,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fundOverview.goal,
            style: TextStyle(
              color: _textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _formatCurrency(fundOverview.currentAmount),
            style: TextStyle(
              color: _primaryColor,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildHeaderButton(context, '충전하기')),
              SizedBox(width: 12),
              Expanded(child: _buildHeaderButton(context, '긴급출금', isOutlined: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(BuildContext context, String text, {bool isOutlined = false}) {
    return ElevatedButton(
      onPressed: () async {
        if (text == '충전하기') {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FundChargeView(fundId: fundOverview.fundId),
            ),
          );
          if(result == true) {
            Navigator.of(context).pop(true);
          }
        } else if (text == '긴급출금') {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FundEmergencyWithdrawalView(fundOverview: fundOverview),
            ),
          );
          if (result == true) {
            Navigator.of(context).pop(true);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isOutlined ? _primaryColor : Colors.white,
        backgroundColor: isOutlined ? Colors.white : _primaryColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isOutlined ? BorderSide(color: _primaryColor) : BorderSide.none,
        ),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDate)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              _formatDate(transaction.date),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _subTextColor,
              ),
            ),
          ),
        Container(
          color: _cardColor,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
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
                      color: _textColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    transaction.type,
                    style: TextStyle(
                      color: _subTextColor,
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
                  SizedBox(height: 4),
                  Text(
                    _formatCurrency(transaction.currentAmount),
                    style: TextStyle(
                      color: _subTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: _backgroundColor),
      ],
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
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}
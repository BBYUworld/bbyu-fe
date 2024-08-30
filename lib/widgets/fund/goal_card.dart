// goal_card.dart
import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/fund/fund_overview.dart';
import 'package:gagyebbyu_fe/models/couple/couple_response.dart';
import 'package:gagyebbyu_fe/models/fund/fund_transaction.dart';
import 'package:gagyebbyu_fe/views/fund/fund_charge_view.dart';
import 'package:gagyebbyu_fe/views/fund/fund_emergency_withdrawal_view.dart';
import 'package:gagyebbyu_fe/views/fund/fund_transaction_view.dart';
import 'package:intl/intl.dart';

class GoalCard extends StatefulWidget {
  final FundOverview fundOverview;
  final CoupleResponse coupleResponse;
  final List<FundTransaction> fundTransactions;
  final VoidCallback reloadData;

  GoalCard({
    required this.fundOverview,
    required this.coupleResponse,
    required this.fundTransactions,
    required this.reloadData,
  });

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {

  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);
  final Color _warningColor = Color(0xFFFF3B30);

  @override
  Widget build(BuildContext context) {
    double progress = (widget.fundOverview.currentAmount / widget.fundOverview.targetAmount).clamp(0, 1);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FundTransactionView(
              transactions: widget.fundTransactions,
              fundOverview: widget.fundOverview,
            ),
          ),
        );
        if (result == true) {
          widget.reloadData();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.fundOverview.goal,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor),
                  ),
                  Icon(Icons.savings, color: _primaryColor, size: 28),
                ],
              ),
              SizedBox(height: 16),
              Text(
                '${_formatCurrency(widget.fundOverview.currentAmount)}',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _primaryColor),
              ),
              Text(
                '목표: ${_formatCurrency(widget.fundOverview.targetAmount)}',
                style: TextStyle(fontSize: 14, color: _subTextColor),
              ),
              SizedBox(height: 12),
              Text('${_formatCurrency(widget.fundOverview.currentAmount)} / ${_formatCurrency(widget.fundOverview.targetAmount)}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: _backgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              ),
              SizedBox(height: 8),
              Text(
                '달성률: ${(progress * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 14, color: _subTextColor),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _buildActionButton('입금하기', _primaryColor, FundChargeView(fundId: widget.fundOverview.fundId))),
                  SizedBox(width: 12),
                  Expanded(child: _buildActionButton('긴급 출금', _warningColor, FundEmergencyWithdrawalView(fundOverview: widget.fundOverview), isOutlined: true)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, Widget destination, {bool isOutlined = false}) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        ).then((_) {
          widget.reloadData();
        });
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: isOutlined ? color : _cardColor,
        backgroundColor: isOutlined ? _cardColor : color,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isOutlined ? BorderSide(color: color) : BorderSide.none,
        ),
        elevation: 0,
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원');
    return formatter.format(amount);
  }
}

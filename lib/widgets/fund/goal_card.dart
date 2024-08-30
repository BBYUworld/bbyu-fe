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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    double progress = (widget.fundOverview.currentAmount / widget.fundOverview.targetAmount).clamp(0, 1);

    return InkWell(
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
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Color(0xffffb6b6),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '현재 모은 돈',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    radius: 20,
                    child: Icon(
                      Icons.attach_money,
                      size: 24,
                      color: Color(0xffffdcd6),
                    ),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text('${_formatCurrency(widget.fundOverview.currentAmount)} / ${_formatCurrency(widget.fundOverview.targetAmount)}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey[300],
                color: Color(0xffff481f),
              ),
              SizedBox(height: 8),
              Text(
                '달성률: ${(progress * 100).toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _isHovered = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _isHovered = false;
                      });
                    },
                    child: Transform.scale(
                      scale: _isHovered ? 1.05 : 1.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FundChargeView(fundId: widget.fundOverview.fundId),
                            ),
                          ).then((_) {
                            widget.reloadData();
                          });
                        },
                        child: Text('입금하기'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FundEmergencyWithdrawalView(fundOverview: widget.fundOverview),
                        ),
                      ).then((_) {
                        widget.reloadData();
                      });
                    },
                    child: Text('긴급 출금'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원');
    return formatter.format(amount);
  }
}

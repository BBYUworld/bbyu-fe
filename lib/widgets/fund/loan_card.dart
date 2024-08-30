// loan_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int loanAmount = 5000000;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Color(0xFFF9FAFB),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '현재 대출',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF6B6B)),
                ),
                Icon(Icons.account_balance_wallet, color: Color(0xFFFF6B6B), size: 28),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '대출 금액: ${_formatCurrency(loanAmount)}',
              style: TextStyle(fontSize: 18, color: Color(0xFFFF6B6B)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원');
    return formatter.format(amount);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/loan/loan.dart';

class RecommendedLoanCard extends StatelessWidget {
  final Loan loan;

  RecommendedLoanCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loan.bankName, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(loan.loanName, style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${loan.interestRate}%'),
                Text('최대 ${loan.maxBalance}원'),
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('신청하기', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              onPressed: () {
                // 대출 신청 로직 구현
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
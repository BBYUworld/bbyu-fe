import 'package:flutter/material.dart';
import '/models/loan/loan.dart';
import '../../../models/loan/loan.dart';

class LoanComparisonCard extends StatelessWidget {
  final Loan loan;

  LoanComparisonCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(loan.bankName[0]),
          backgroundColor: Colors.blue,
        ),
        title: Text(loan.loanName),
        subtitle: Text('${loan.interestRate}% | 최대 ${loan.maxBalance}원'),
        trailing: ElevatedButton(
          child: Text('신청',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
          onPressed: () {
            // 대출 신청 로직 구현
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ),
    );
  }
}
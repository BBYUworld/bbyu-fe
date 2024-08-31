
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanBalanceCard extends StatelessWidget {
  final int balance;

  LoanBalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {

    // 100000000(1억)으로 나눈 몫은 억, 나머지를 10000(1만)으로 나눈 몫은 만원 단위
    int balanceInEok = balance ~/ 100000000;  // 억 단위
    int balanceInManwon = (balance % 100000000) ~/ 10000;  // 만원 단위

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('우리의 대출액은 얼마일까요?', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('대출 잔액', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              '${balanceInEok > 0 ? '$balanceInEok억 ' : ''}${balanceInManwon}만원',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              ],
            ),
          ],
        ),
      ),
    );
  }
}
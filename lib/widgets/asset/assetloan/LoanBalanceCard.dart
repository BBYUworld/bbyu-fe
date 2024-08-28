
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanBalanceCard extends StatelessWidget {
  final int balance;

  LoanBalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    // 10000으로 나눈 몫은 억, 나머지는 만원 단위
    int balancem= balance;
    int balanceInEok = balance ~/ 10000;  // 억 단위
    int balanceInManwon = (balance % 10000);  // 만원 단위

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${balancem}'),
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
                ElevatedButton(onPressed: () {}, child: Text('내 납부내역')),
                ElevatedButton(onPressed: () {}, child: Text('납부 일정')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
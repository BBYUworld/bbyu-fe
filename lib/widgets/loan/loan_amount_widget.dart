import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoanAmountInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  LoanAmountInputWidget({required this.controller, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '대출받을 금액을 입력해주세요!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '금액 입력',
                      suffixText: '만원',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}
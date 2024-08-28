import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreditScoreTipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('신용점수 팁'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // 신용점수 팁 페이지로 이동하는 로직
        },
      ),
    );
  }
}
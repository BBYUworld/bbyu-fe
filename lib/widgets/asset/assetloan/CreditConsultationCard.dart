import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreditConsultationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('신용 전문가와 상담하기'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // 상담 페이지로 이동하는 로직
        },
      ),
    );
  }
}
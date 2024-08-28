import 'package:flutter/material.dart';
import '/models/asset/asset_loan.dart';
import 'package:intl/intl.dart';
import '/views/asset/assetloan/LoanDetailPage.dart';

class LoanListCard extends StatelessWidget {
  final List<AssetLoan> loans;
  final NumberFormat formatter = NumberFormat('#,###');

  LoanListCard({required this.loans});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '내 대출 목록',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: loans.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final loan = loans[index];
              return ListTile(
                title: Text(loan.loanName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${loan.bankName}'),
                    Text('금리: ${loan.interestRate.toStringAsFixed(2)}%'),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('잔여액: ${formatter.format(loan.remainedAmount)}만원'),
                    Text('대출액: ${formatter.format(loan.amount)}만원', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoanDetailPage(assetId: loan.assetId),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
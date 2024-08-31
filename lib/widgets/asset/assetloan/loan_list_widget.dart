import 'package:flutter/material.dart';
import '/models/asset/asset_loan.dart';
import 'package:intl/intl.dart';
import '/views/asset/assetloan/loan_detail_page.dart';

class LoanListCard extends StatefulWidget {
  final List<AssetLoan> loans;

  LoanListCard({required this.loans});

  @override
  _LoanListCardState createState() => _LoanListCardState();
}

class _LoanListCardState extends State<LoanListCard> {
  final NumberFormat formatter = NumberFormat('#,###');
  int displayCount = 5;

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
              '우리의 대출 목록',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.loans.length > displayCount ? displayCount : widget.loans.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final loan = widget.loans[index];
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
                    Text('${loan.user1Name}'),
                    Text('잔여액: ${formatter.format(loan.remainedAmount)}원'),
                    Text('대출액: ${formatter.format(loan.amount)}원', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
          if (widget.loans.length > displayCount)
            Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: ElevatedButton(
                  child: Text('더보기'),
                  onPressed: () {
                    setState(() {
                      displayCount += 5;
                      if (displayCount > widget.loans.length) {
                        displayCount = widget.loans.length;
                      }
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
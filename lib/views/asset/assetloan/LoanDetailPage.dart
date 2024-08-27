import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/asset/asset_loan.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';

class LoanDetailPage extends StatefulWidget {
  final int assetId;

  LoanDetailPage({required this.assetId});

  @override
  _LoanDetailPageState createState() => _LoanDetailPageState();
}

class _LoanDetailPageState extends State<LoanDetailPage> {
  late Future<AssetLoan> futureLoanDetail;

  @override
  void initState() {
    super.initState();
    futureLoanDetail = ApiService().fetchLoanDetail(widget.assetId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대출 상세 정보'),
      ),
      body: FutureBuilder<AssetLoan>(
        future: futureLoanDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final loan = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('대출명: ${loan.loanName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('은행: ${loan.bankName}'),
                  Text('금리: ${loan.interestRate.toStringAsFixed(2)}%'),
                  Text('대출액: ${loan.amount}원'),
                  Text('잔여액: ${loan.remainedAmount}원'),
                  // 추가 대출 정보를 여기에 표시
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
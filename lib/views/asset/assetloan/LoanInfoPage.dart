
import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import 'package:gagyebbyu_fe/models/asset/asset_loan.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/UserInfoCard.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/LoanBalanceCard.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/LoanListCard.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/CreditConsultationCard.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/CreditScoreTipsCard.dart';

class LoanInfoPage extends StatefulWidget {
  @override
  _LoanInfoPageState createState() => _LoanInfoPageState();
}

class _LoanInfoPageState extends State<LoanInfoPage> {
  late Future<List<AssetLoan>> futureLoans;

  @override
  void initState() {
    super.initState();
    futureLoans = ApiService().fetchAssetLoans();
  }

  @override
  Widget build(BuildContext context) {
    print('info page build');
    return FutureBuilder<List<AssetLoan>>(
      future: futureLoans,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<AssetLoan> loans = snapshot.data!;
          int totalLoanAmount = loans.fold(0, (sum, loan) => sum + loan.remainedAmount);
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  UserInfoCard(name: "김씨", creditScore: 750),
                  SizedBox(height: 16),
                  LoanBalanceCard(balance: totalLoanAmount),
                  SizedBox(height: 16),
                  LoanListCard(loans: loans),
                  SizedBox(height: 16),
                  CreditConsultationCard(),
                  SizedBox(height: 16),
                  CreditScoreTipsCard(),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text('No loans available'));
        }
      },
    );
  }
}
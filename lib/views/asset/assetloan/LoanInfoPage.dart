
import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/couple/couple_response.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import 'package:gagyebbyu_fe/models/asset/asset_loan.dart';
import 'package:gagyebbyu_fe/services/user_api_service.dart';
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
  late Future<CoupleResponse> futureCouple;

  @override
  void initState() {
    super.initState();
    futureLoans = ApiService().fetchAssetLoans();
    futureCouple = ApiService().findCouple();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([futureLoans, futureCouple]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final loans = snapshot.data![0] as List<AssetLoan>;
          final couple = snapshot.data![1] as CoupleResponse;

          int totalLoanAmount = loans.fold(0, (sum, loan) => sum + loan.remainedAmount);

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  UserInfoCard(name:  "Unknown", creditScore: 0),
                  SizedBox(height: 16),
                  UserInfoCard(name:  "Unknown", creditScore: 0),
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
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/couple/couple_response.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import 'package:gagyebbyu_fe/models/asset/asset_loan.dart';
import 'package:gagyebbyu_fe/services/user_api_service.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/UserInfoCard.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/loan_balance_widget.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/loan_list_widget.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/CreditConsultationCard.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/CreditScoreTipsCard.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/couple_user_info_widget.dart';

class LoanInfoPage extends StatefulWidget {
  @override
  _LoanInfoPageState createState() => _LoanInfoPageState();
}

class _LoanInfoPageState extends State<LoanInfoPage> {
  late Future<List<AssetLoan>> futureLoans;
  late Future<CoupleResponse> futureCouple;
  late Future<int> remainedMoney;

  @override
  void initState() {
    super.initState();
    futureLoans = ApiService().fetchgetCoupleLoan();
    futureCouple = ApiService().fetchCoupleInfo();
    remainedMoney = ApiService().fetchSumRemainAmount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([futureLoans, remainedMoney, futureCouple]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final loans = snapshot.data![0] as List<AssetLoan>;
          final remainedAmount = snapshot.data![1] as int;
          final couple = snapshot.data![2] as CoupleResponse;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CoupleUserInfoCard(
                    coupleName: couple.nickname,
                    user1Name: couple.user1Name ?? "Unknown",
                    user2Name: couple.user2Name ?? "Unknown",
                    user1RatingName: couple.user1RatingName ?? "N",
                    user2RatingName: couple.user2RatingName ?? "N",

                  ),
                  LoanBalanceCard(balance: remainedAmount),
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
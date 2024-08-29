import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/account/account_recommendation.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import '../../../widgets/asset/assetloan/loan_balance_widget.dart';
import '../../../widgets/asset/assetloan/account_recommendation_widget.dart';

class AssetRecommendedPage extends StatefulWidget {
  @override
  _AssetRecommendedPageState createState() => _AssetRecommendedPageState();
}

class _AssetRecommendedPageState extends State<AssetRecommendedPage> {
  late Future<int> sumRemainedAmount;
  late Future<AccountRecommendation> accountRecommendations;

  @override
  void initState() {
    super.initState();
    sumRemainedAmount = ApiService().fetchSumRemainAmount();
    accountRecommendations = ApiService().fetchAccountRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('맞춤 금융상품', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([sumRemainedAmount, accountRecommendations]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          } else if (snapshot.hasError) {
            return Center(child: Text('에러가 발생했습니다: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData) {
            return Center(child: Text('데이터가 없습니다.', style: TextStyle(color: Colors.grey)));
          }

          int totalLoanAmount = snapshot.data![0] as int;
          AccountRecommendation recommendations = snapshot.data![1] as AccountRecommendation;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('부부를 위한 맞춤 금융상품', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('당신의 재무 상황에 맞는 최적의 상품을 추천해드려요', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: AccountSelectionWidget(recommendations: recommendations),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LoanBalanceCard(balance: totalLoanAmount),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        child: Text('대출 추천받으러 가기', style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/loan');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
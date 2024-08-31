import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/account/account_recommendation.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import 'package:gagyebbyu_fe/widgets/custom_loading_widget.dart';
import '../../../widgets/asset/assetloan/loan_balance_widget.dart';
import '../../../widgets/asset/assetloan/account_recommendation_widget.dart';

class AssetRecommendedPage extends StatefulWidget {
  @override
  _AssetRecommendedPageState createState() => _AssetRecommendedPageState();
}

class _AssetRecommendedPageState extends State<AssetRecommendedPage> {
  late Future<int> sumRemainedAmount;
  late Future<AccountRecommendation> accountRecommendations;
  bool isLoading = true;

  final Color primaryColor = Color(0xFFFF6B6B);
  final Color backgroundColor = Color(0xFFF9FAFB);
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF4A4A4A);
  final Color subtextColor = Color(0xFF8B95A1);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    sumRemainedAmount = ApiService().fetchSumRemainAmount();
    accountRecommendations = ApiService().fetchAccountRecommendations();

    await Future.wait([sumRemainedAmount, accountRecommendations]);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('맞춤 금융 상품', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? CustomLoadingWidget(
        loadingTexts: [
          '쀼AI가 맞춤 금융상품을 찾고 있어요!!',
          '거의 다 왔어요! 쀼AI가 열심히 찾구있어요!!',
          '조금만 더 기다려주세요!',
          '쀼AI가 최적의 상품을 선별 중입니다!'
        ],
        imagePath: 'assets/loan_image/loan_info2.png',
      )
          : _buildPageContent(),
    );
  }

  Widget _buildPageContent() {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([sumRemainedAmount, accountRecommendations]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('에러가 발생했습니다: ${snapshot.error}', style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData) {
          return Center(child: Text('데이터가 없습니다.', style: TextStyle(color: subtextColor)));
        }

        int totalLoanAmount = snapshot.data![0] as int;
        AccountRecommendation recommendations = snapshot.data![1] as AccountRecommendation;

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('나만을 위한 맞춤 금융 상품',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                    SizedBox(height: 10),
                    Text('쀼AI가 당신의 재무 상황을 분석해 최적의 상품을 추천해드렸어요',
                        style: TextStyle(color: subtextColor)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: AccountSelectionWidget(recommendations: recommendations),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: LoanBalanceCard(balance: totalLoanAmount),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  child: Text('대출 추천받으러 가기', style: TextStyle(fontSize: 16)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/loan');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
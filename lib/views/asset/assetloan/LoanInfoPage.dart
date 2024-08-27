
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

class _LoanInfoPageState extends State<LoanInfoPage> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  late Future<List<AssetLoan>> futureLoans;

  @override
  void initState() {
    super.initState();
    futureLoans = ApiService().fetchAssetLoans();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('내 대출정보'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '내 대출정보'),
            Tab(text: '대출추천'),
          ],
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.0),
            insets: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      ),
      body: FutureBuilder<List<AssetLoan>>(
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
                    UserInfoCard(name: "김씨", creditScore: 750), // 임시 데이터
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: '대시보드'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '상품'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}
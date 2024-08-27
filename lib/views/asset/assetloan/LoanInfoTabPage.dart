import 'package:flutter/material.dart';
import 'LoanInfoPage.dart';
import 'LoanRecommendationPage.dart';

class LoanInfoTabPage extends StatefulWidget {
  @override
  _LoanInfoTabPageState createState() => _LoanInfoTabPageState();
}

class _LoanInfoTabPageState extends State<LoanInfoTabPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
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
        title: Text('대출 정보'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 뒤로 가기 버튼 추가
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '내 대출정보'),
            Tab(text: '대출추천'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LoanInfoPage(),
          LoanRecommendationPage(),
        ],
      ),
    );
  }
}
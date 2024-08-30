import 'package:flutter/material.dart';
import 'loan_info_page.dart';
import 'loan_recommendation_page.dart';

class LoanMainPage extends StatefulWidget {
  @override
  _LoanMainPageState createState() => _LoanMainPageState();
}

class _LoanMainPageState extends State<LoanMainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});  // 탭 변경 시 화면 갱신
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('LoanMainPage build');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('내 대출정보'),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Tab> [
            Tab(text: '내 대출정보'),
            Tab(text: '대출추천'),
          ],
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.0),
            insets: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          LoanInfoPage(),
          LoanRecommendationPage(),
        ],
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
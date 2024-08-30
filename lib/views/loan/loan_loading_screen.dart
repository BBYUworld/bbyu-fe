import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/loan_comparison_widget.dart';
import '/models/loan/loan.dart';
import '/services/api_service.dart';
import 'package:intl/intl.dart';

class LoanLoadingScreen extends StatefulWidget {
  @override
  _LoanLoadingScreenState createState() => _LoanLoadingScreenState();
}

class _LoanLoadingScreenState extends State<LoanLoadingScreen> {
  double _progress = 0.0;
  List<String> _loadingTexts = ['최적의 대출 상품을 찾고 있어요', '거의 다 왔어요!', '조금만 더 기다려주세요'];
  int _currentTextIndex = 0;
  Timer? _textTimer;
  Timer? _progressTimer;
  late Future<List<Loan>> futureRecommendedLoans;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _startTextRotation();
    _startProgressAnimation();
    _loadData();
  }

  void _loadData() async {
    try {
      final loans = await ApiService().fetchRecommendedLoans();
      setState(() {
        futureRecommendedLoans = Future.value(loans);
        _isDataLoaded = true;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        futureRecommendedLoans = Future.error(e);
        _isDataLoaded = true;
      });
    }
  }

  void _startTextRotation() {
    _textTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % _loadingTexts.length;
        });
      }
    });
  }

  void _startProgressAnimation() {
    const totalDuration = Duration(seconds: 15);
    const updateInterval = Duration(milliseconds: 100);
    final stepValue = 1 / (totalDuration.inMilliseconds / updateInterval.inMilliseconds);

    _progressTimer = Timer.periodic(updateInterval, (timer) {
      if (mounted) {
        setState(() {
          if (_progress < 0.95) {  // 95%까지만 자동으로 증가
            _progress += stepValue;
          } else if (_isDataLoaded) {  // 데이터가 로드되면 100%로 설정
            _progress = 1.0;
            _progressTimer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('대출받기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isDataLoaded && _progress >= 1.0
          ? FutureBuilder<List<Loan>>(
        future: futureRecommendedLoans,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorView(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return _buildLoanListView(snapshot.data!);
          } else {
            return _buildEmptyView();
          }
        },
      )
          : _buildLoadingView(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3182F6)),
            strokeWidth: 5,
          ),
          SizedBox(height: 40),
          Text(
            _loadingTexts[_currentTextIndex],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          SizedBox(height: 20),
          Text(
            '${(_progress * 100).toInt()}%',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3182F6)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 20),
          Text(
            '오류가 발생했습니다',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 10),
          Text(
            error,
            style: TextStyle(fontSize: 14, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 60, color: Color(0xFF3182F6)),
          SizedBox(height: 20),
          Text(
            '대출 정보가 없습니다',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanListView(List<Loan> loans) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          '대출 순위 보기',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 20),
        ...loans.map((loan) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: LoanComparisonCard(loan: loan),
        )).toList(),
      ],
    );
  }
}
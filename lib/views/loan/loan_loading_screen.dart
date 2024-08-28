import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/widgets/asset/assetloan/LoanComparisonCard.dart';
import '/models/loan/loan.dart';
import '/services/api_service.dart';
import 'package:intl/intl.dart';

class LoanLoadingScreen extends StatefulWidget {
  @override
  _LoanLoadingScreenState createState() => _LoanLoadingScreenState();
}

class _LoanLoadingScreenState extends State<LoanLoadingScreen> {
  double _progress = 0.0;
  List<String> _images = ['image1.jpg', 'image2.jpg', 'image3.jpg'];
  int _currentImageIndex = 0;
  Timer? _imageTimer;
  Timer? _progressTimer;
  late Future<List<Loan>> futureRecommendedLoans;

  @override
  void initState() {
    super.initState();
    _startImageRotation();
    _startProgressAnimation();
    futureRecommendedLoans = ApiService().fetchRecommendedLoans();
  }

  void _startImageRotation() {
    _imageTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  void _startProgressAnimation() {
    _progressTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.01;
        } else {
          _progressTimer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _imageTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대출받기'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<Loan>>(
        future: futureRecommendedLoans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || _progress < 1.0) {
            return _buildLoadingView();
          } else if (snapshot.hasError) {
            return _buildErrorView(snapshot.error.toString());
          } else if (snapshot.hasData && _progress >= 1.0) {
            return _buildLoanListView(snapshot.data!);
          } else {
            return _buildEmptyView();
          }
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/loading/${_images[_currentImageIndex]}', height: 200),
          SizedBox(height: 20),
          Text('화면을 나가지 않고 기다려주세요!'),
          SizedBox(height: 20),
          Text('${(_progress * 100).toInt()}%'),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Text('오류가 발생했습니다: $error', style: TextStyle(color: Colors.red)),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Text('대출 정보가 없습니다.'),
    );
  }

  Widget _buildLoanListView(List<Loan> loans) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('대출 순위 보기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...loans.map((loan) => LoanComparisonCard(loan: loan)).toList(),
      ],
    );
  }
}
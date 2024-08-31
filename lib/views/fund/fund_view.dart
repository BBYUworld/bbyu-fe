import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/fund/fund_overview.dart';
import 'package:gagyebbyu_fe/models/couple/couple_response.dart';
import 'package:gagyebbyu_fe/models/fund/fund_transaction.dart';
import 'package:gagyebbyu_fe/widgets/fund/transaction_chart.dart';
import 'package:gagyebbyu_fe/widgets/fund/goal_card.dart';
import 'package:gagyebbyu_fe/widgets/fund/emergency_card.dart';
import 'package:gagyebbyu_fe/widgets/fund/loan_card.dart';
import 'package:gagyebbyu_fe/views/fund/fund_create_view.dart';
import 'package:http/http.dart' as http;
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'dart:convert';

import '../home/Footer.dart';

class FundView extends StatefulWidget {
  @override
  _FundViewState createState() => _FundViewState();
}

class _FundViewState extends State<FundView> {
  final String baseURL = 'http://3.39.19.140:8080/api';
  Future<Map<String, dynamic>>? _initialDataFuture;
  final TokenStorage _tokenStorage = TokenStorage();
  int _selectedIndex = 3;

  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);

  @override
  void initState() {
    super.initState();
    _initialDataFuture = fetchInitialData();
  }

  Future<Map<String, dynamic>> fetchInitialData() async {
    try {
      final coupleResponse = await fetchCoupleResponse();
      final fundOverview = await fetchFundOverview(coupleResponse.coupleId);
      final fundTransactions = await fetchFundTransactions(fundOverview.fundId);

      return {
        'coupleResponse': coupleResponse,
        'fundOverview': fundOverview,
        'fundTransactions': fundTransactions,
      };
    } catch (e) {
      print('Error fetching initial data: $e');
      throw Exception('Error fetching initial data: $e');
    }
  }

  Future<CoupleResponse> fetchCoupleResponse() async {
    final url = Uri.parse('$baseURL/couple'); // baseURL과 엔드포인트 결합
    final accessToken = await _tokenStorage.getAccessToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return CoupleResponse.fromJson(jsonResponse);
      } else {
        print('Failed to load couple response. Status code: ${response.statusCode}');
        throw Exception('Failed to load couple response');
      }
    } catch (e) {
      print('Error fetching couple response: $e');
      throw Exception('Error fetching couple response: $e');
    }
  }

  Future<FundOverview> fetchFundOverview(int coupleId) async {
    final url = Uri.parse('$baseURL/fund/$coupleId'); // baseURL과 엔드포인트 결합
    final accessToken = await _tokenStorage.getAccessToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return FundOverview.fromJson(jsonResponse);
      } else {
        print('Failed to load fund overview. Status code: ${response.statusCode}');
        throw Exception('Failed to load fund overview');
      }
    } catch (e) {
      print('Error fetching fund overview: $e');
      throw Exception('Error fetching fund overview: $e');
    }
  }

  Future<List<FundTransaction>> fetchFundTransactions(int fundId) async {
    final url = Uri.parse('$baseURL/fund/transaction/$fundId'); // baseURL과 엔드포인트 결합
    final accessToken = await _tokenStorage.getAccessToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((data) => FundTransaction.fromJson(data)).toList();
      } else {
        print('Failed to load fund transactions. Status code: ${response.statusCode}');
        throw Exception('Failed to load fund transactions');
      }
    } catch (e) {
      print('Error fetching fund transactions: $e');
      throw Exception('Error fetching fund transactions: $e');
    }
  }

  void _reloadData() {
    setState(() {
      _initialDataFuture = fetchInitialData();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          '펀드 관리',
          style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _initialDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_primaryColor)));
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => FundCreateView()),
              );
            });
            return SizedBox.shrink();
          } else if (snapshot.hasData) {
            final coupleResponse = snapshot.data!['coupleResponse'] as CoupleResponse;
            final fundOverview = snapshot.data!['fundOverview'] as FundOverview;
            final fundTransactions = snapshot.data!['fundTransactions'] as List<FundTransaction>;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCoupleInfo(coupleResponse, fundOverview),
                    SizedBox(height: 24),
                    GoalCard(fundOverview: fundOverview, coupleResponse: coupleResponse, fundTransactions: fundTransactions, reloadData: _reloadData),
                    SizedBox(height: 16),
                    LoanCard(fundOverview: fundOverview),
                    SizedBox(height: 16),
                    EmergencyCard(fundOverview: fundOverview),
                    SizedBox(height: 16),
                    TransactionChart(fundOverview: fundOverview, fundTransactions: fundTransactions),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('표시할 데이터가 없습니다.', style: TextStyle(color: _textColor)));
          }
        },
      ),
      bottomNavigationBar: CustomFooter(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildCoupleInfo(CoupleResponse coupleResponse, FundOverview fundOverview) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${coupleResponse.nickname} 펀딩',
            style: TextStyle(fontSize: 14, color: _subTextColor),
          ),
          SizedBox(height: 4),
          Text(
            '${fundOverview.goal}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textColor),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${coupleResponse.user1Name}',
                style: TextStyle(fontSize: 16, color: _textColor),
              ),
              SizedBox(width: 8),
              Icon(Icons.favorite, color: _primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                '${coupleResponse.user2Name}',
                style: TextStyle(fontSize: 16, color: _textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
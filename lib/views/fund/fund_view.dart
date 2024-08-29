// fund_view.dart
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

class FundView extends StatefulWidget {
  @override
  _FundViewState createState() => _FundViewState();
}

class _FundViewState extends State<FundView> {
  Future<Map<String, dynamic>>? _initialDataFuture;
  final TokenStorage _tokenStorage = TokenStorage();

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
    final url = Uri.parse('http://10.0.2.2:8080/api/couple');
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
    final url = Uri.parse('http://10.0.2.2:8080/api/fund/$coupleId');
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
    final url = Uri.parse('http://10.0.2.2:8080/api/fund/transaction/$fundId');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '펀드 관리',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFC8D94),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _initialDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${coupleResponse.nickname} 펀딩',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Colors.black54),
                        ),
                        SizedBox(height: 0),
                        Text(
                          '${fundOverview.goal}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${coupleResponse.user1Name} ',
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                            Image.asset(
                              'assets/images/heart.png',
                              width: 25,
                              height: 25,
                            ),
                            Text(
                              ' ${coupleResponse.user2Name}',
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  GoalCard(fundOverview: fundOverview, coupleResponse: coupleResponse, fundTransactions: fundTransactions, reloadData: _reloadData),
                  SizedBox(height: 16),
                  LoanCard(),
                  SizedBox(height: 16),
                  EmergencyCard(fundOverview: fundOverview),
                  SizedBox(height: 16),
                  TransactionChart(fundOverview: fundOverview, fundTransactions: fundTransactions),
                ],
              ),
            );
          } else {
            return Center(child: Text('표시할 데이터가 없습니다.'));
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/fund/fund_overview.dart';
import 'package:gagyebbyu_fe/models/couple/couple_response.dart';
import 'package:gagyebbyu_fe/models/fund/fund_transaction.dart';
import 'package:gagyebbyu_fe/views/fund/fund_transaction_view.dart';
import 'package:gagyebbyu_fe/views/fund/fund_create_view.dart';
import 'package:http/http.dart' as http;
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
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
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _initialDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Navigate to FundCreateView if there is an error
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => FundCreateView()),
              );
            });
            return SizedBox.shrink(); // Return an empty widget until navigation completes
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
                        SizedBox(height: 0), // 두 텍스트 사이의 간격
                        Text(
                          '${fundOverview.goal}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                          children: [
                            Text(
                              '${coupleResponse.user1Name} ',
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                            Image.asset(
                              'assets/images/heart.png', // 이미지 경로
                              width: 25, // 원하는 크기로 조정
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
                  _buildGoalCard(fundOverview, coupleResponse, fundTransactions),
                  SizedBox(height: 16),
                  _buildLoanCard(),
                  SizedBox(height: 16),
                  _buildEmergencyCard(fundOverview),
                  SizedBox(height: 16),
                  _buildTransactionChart(fundOverview, fundTransactions),
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

  Widget _buildGoalCard(FundOverview fundOverview, CoupleResponse coupleResponse, List<FundTransaction> fundTransactions) {
    double progress = (fundOverview.currentAmount / fundOverview.targetAmount).clamp(0, 1);

    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FundTransactionView(
              transactions: fundTransactions,
              fundOverview: fundOverview,
            ),
          ),
        );
        if (result == true) {
          _reloadData();
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.pinkAccent[100],
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '현재 모은 돈',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    radius: 20,
                    child: Icon(
                      Icons.attach_money, // 돈 아이콘
                      size: 24, // 아이콘 크기
                      color: Colors.pinkAccent[100], // 아이콘 색상
                    ),
                    backgroundColor: Colors.white, // 배경색
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(height: 0),
              Text('${_formatCurrency(fundOverview.currentAmount)} / ${_formatCurrency(fundOverview.targetAmount)}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey[300],
                color: Colors.pink,
              ),
              SizedBox(height: 8),
              Text(
                '달성률: ${(progress * 100).toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanCard() {
    int loanAmount = 5000000;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Colors.redAccent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '현재 대출',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '대출 금액: ${_formatCurrency(loanAmount)}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(FundOverview data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('비상금 사용 현황', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              children: [
                Text('사용 여부: ', style: TextStyle(fontSize: 16)),
                Text(
                  data.isEmergencyUsed > 0 ? '사용함' : '사용 안함',
                  style: TextStyle(
                    fontSize: 16,
                    color: data.isEmergencyUsed > 0 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('비상금 사용 횟수: ${data.emergencyCount}회', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionChart(FundOverview fundOverview, List<FundTransaction> transactions) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('펀드 거래 내역', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Container(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: fundOverview.targetAmount / 5,
                      getTitles: (value) {
                        return _formatCurrency(value.toInt());
                      },
                    ),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        int index = value.toInt();
                        List<DateTime> sortedDates = _getSortedDates(fundOverview, transactions);

                        if (index < sortedDates.length) {
                          return DateFormat('MM/dd').format(sortedDates[index]);
                        }
                        return '';
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateDataPoints(fundOverview, transactions),
                      isCurved: true,
                      colors: [Colors.pinkAccent],
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  minY: 0,
                  maxY: fundOverview.targetAmount.toDouble(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _getSortedDates(FundOverview fundOverview, List<FundTransaction> transactions) {
    Map<DateTime, double> dateToAmountMap = {};

    // 첫 번째 데이터 포인트는 펀드 시작 날짜로 설정
    DateTime startDate = DateTime(fundOverview.startDate.year, fundOverview.startDate.month, fundOverview.startDate.day);
    dateToAmountMap[startDate] = 0;

    // 날짜별로 amount 합산
    for (var transaction in transactions) {
      DateTime date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      if (dateToAmountMap.containsKey(date)) {
        dateToAmountMap[date] = dateToAmountMap[date]! + transaction.amount.toDouble();
      } else {
        dateToAmountMap[date] = transaction.amount.toDouble();
      }
    }

    return dateToAmountMap.keys.toList()..sort();
  }

  List<FlSpot> _generateDataPoints(FundOverview fundOverview, List<FundTransaction> transactions) {
    Map<DateTime, double> dateToAmountMap = {};

    // 첫 번째 데이터 포인트는 펀드 시작 날짜로 설정
    DateTime startDate = DateTime(fundOverview.startDate.year, fundOverview.startDate.month, fundOverview.startDate.day);
    dateToAmountMap[startDate] = 0;

    // 날짜별로 amount 합산
    for (var transaction in transactions) {
      DateTime date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      if (dateToAmountMap.containsKey(date)) {
        dateToAmountMap[date] = dateToAmountMap[date]! + transaction.amount.toDouble();
      } else {
        dateToAmountMap[date] = transaction.amount.toDouble();
      }
    }

    // 누적 합 계산
    double cumulativeAmount = 0;
    List<FlSpot> dataPoints = [];
    List<DateTime> sortedDates = dateToAmountMap.keys.toList()..sort();

    for (int i = 0; i < sortedDates.length; i++) {
      cumulativeAmount += dateToAmountMap[sortedDates[i]]!;
      dataPoints.add(FlSpot(i.toDouble(), cumulativeAmount));
    }

    return dataPoints;
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원');
    return formatter.format(amount);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  int _calculateRemainingDays(DateTime endDate) {
    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }
}
